<?php

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 */

require_once('Turbo.php');

class ProjectsCategories extends Turbo
{
	// Список указателей на категории в дереве категорий (ключ = id категории)
	private $all_projects_categories;
	// Дерево категорий
	private $projects_categories_tree;

	// Функция возвращает массив категорий
	public function get_projects_categories($filter = array())
	{
		if(!isset($this->projects_categories_tree))
			$this->init_projects_categories();
 
		return $this->all_projects_categories;
	}	

    // Функция возвращает дерево категорий
	public function get_projects_categories_tree()
	{
		if(!isset($this->projects_categories_tree))
			$this->init_projects_categories();
			
		return $this->projects_categories_tree;
	}

	// Функция возвращает заданную категорию
	public function get_projects_category($id)
	{
		if(!isset($this->all_projects_categories))
			$this->init_projects_categories();
		if(is_int($id) && array_key_exists(intval($id), $this->all_projects_categories))
			return $category = $this->all_projects_categories[intval($id)];
		elseif(is_string($id))
			foreach ($this->all_projects_categories as $category)
				if ($category->url == $id)
					return $this->get_projects_category((int)$category->id);	
		
		return false;
        }
	
	// Добавление категории
	public function add_projects_category($category)
	{
		$category = (array)$category;
		if(empty($category['url']))
		{
			$category['url'] = preg_replace("/[\s]+/ui", '_', $category['name']);
			$category['url'] = strtolower(preg_replace("/[^0-9a-zа-я_]+/ui", '', $category['url']));
		}	

		// Если есть категория с таким URL, добавляем к нему число
		while($this->get_projects_category((string)$category['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $category['url'], $parts))
				$category['url'] = $parts[1].'_'.($parts[2]+1);
			else
				$category['url'] = $category['url'].'_2';
		}
		
		$category = (object)$category;

 	    $result = $this->languages->get_description($category, 'project_category');
        if(!empty($result->data))$category = $result->data;

		$this->db->query("INSERT INTO __projects_categories SET ?%", $category);
		$id = $this->db->insert_id();
		$this->db->query("UPDATE __projects_categories SET position=id WHERE id=?", $id);			
		
		if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'project_category');
        }
		
		unset($this->projects_categories_tree);
		unset($this->all_projects_categories);
		return intval($id);
	}
	
	// Изменение категории
	public function update_projects_category($id, $category)
	{
		$category = (object)$category;
	    $result = $this->languages->get_description($category, 'project_category');
        if(!empty($result->data))$category = $result->data;
		
		$query = $this->db->placehold("UPDATE __projects_categories SET `last_modified`=NOW(), ?% WHERE id=? LIMIT 1", $category, intval($id));
		$this->db->query($query);
		
		
		if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'project_category', $this->languages->lang_id());
        }
		
		unset($this->projects_categories_tree);
		unset($this->all_projects_categories);
		return intval($id);
	}
	
	// Удаление категории
	public function delete_projects_category($id)
	{
		if(!$category = $this->get_projects_category(intval($id)))
			return false;
		foreach($category->children as $id)
		{
			if(!empty($id))
			{
				$this->delete_image($id);
				$query = $this->db->placehold("DELETE FROM __projects_categories WHERE id=? LIMIT 1", $id);
				$this->db->query($query);
				$query = $this->db->placehold("DELETE FROM __projects_categories WHERE category_id=?", $id);
				$this->db->query($query);
				$this->init_projects_categories();
				$this->db->query($query);
                $this->db->query("DELETE FROM __lang_projects_categories WHERE project_category_id in(?@)", $category->children);
			}
		}
		return true;
	}

	// Удалить изображение категории
	public function delete_image($category_id)
	{
		$query = $this->db->placehold("SELECT image FROM __projects_categories WHERE id=?", $category_id);
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __projects_categories SET image=NULL WHERE id=?", $category_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __projects_categories WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
                {
                    $file = pathinfo($filename, PATHINFO_FILENAME);
                    $ext = pathinfo($filename, PATHINFO_EXTENSION);
					$webp = 'webp';
            
                    // Удалить все ресайзы
                    $rezised_images = glob($this->config->root_dir.$this->config->resized_category_images_dir.$file."*.".$ext);
                    if(is_array($rezised_images)) {
                        foreach (glob($this->config->root_dir.$this->config->resized_category_images_dir.$file."*.".$ext) as $f) {
                            @unlink($f);
                        }
                    }
					
					$rezised_images = glob($this->config->root_dir.$this->config->resized_category_images_dir.$file."*.".$webp);
                    if(is_array($rezised_images)) {
                        foreach (glob($this->config->root_dir.$this->config->resized_category_images_dir.$file."*.".$webp) as $f) {
                            @unlink($f);
                        }
                    }
					
                    @unlink($this->config->root_dir.$this->config->categories_images_dir.$filename);
                }
			$this->init_projects_categories();
		}
	}

	// Инициализация категорий, после которой категории будем выбирать из локальной переменной
	private function init_projects_categories()
	{
		// Дерево категорий
		$tree = new stdClass();
		$tree->subcategories = array();
		
		// Указатели на узлы дерева
		$pointers = array();
		$pointers[0] = &$tree;
		$pointers[0]->path = array();
		
		$lang_sql = $this->languages->get_query(array('object'=>'project_category', 'px'=>'c'));
		
		// Выбираем все категории
		$query = $this->db->placehold("SELECT c.id, c.parent_id, c.name, c.name_h1, c.description, c.url, c.meta_title, c.meta_keywords, c.meta_description, c.image, c.visible, c.position, c.last_modified, ".$lang_sql->fields." 
										FROM __projects_categories c ".$lang_sql->join." ORDER BY c.parent_id, c.position");
											
		$this->db->query($query);
		$projects_categories = $this->db->results();
				
		$finish = false;
		// Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
		while(!empty($projects_categories)  && !$finish)
		{
			$flag = false;
			// Проходим все выбранные категории
			foreach($projects_categories as $k=>$category)
			{
				if(isset($pointers[$category->parent_id]))
				{
					// В дерево категорий (через указатель) добавляем текущую категорию
					$pointers[$category->id] = $pointers[$category->parent_id]->subcategories[] = $category;
					
					// Путь к текущей категории
					$curr = $pointers[$category->id];
					$pointers[$category->id]->path = array_merge((array)$pointers[$category->parent_id]->path, array($curr));
					
					// Убираем использованную категорию из массива категорий
					unset($projects_categories[$k]);
					$flag = true;
				}
			}
			if(!$flag) $finish = true;
		}
		
		// Для каждой категории id всех ее деток узнаем
		$ids = array_reverse(array_keys($pointers));
		foreach($ids as $id)
		{
			if($id>0)
			{
				$pointers[$id]->children[] = $id;

				if(isset($pointers[$pointers[$id]->parent_id]->children))
					$pointers[$pointers[$id]->parent_id]->children = array_merge($pointers[$id]->children, $pointers[$pointers[$id]->parent_id]->children);
				else
					$pointers[$pointers[$id]->parent_id]->children = $pointers[$id]->children;
			}
		}
		unset($pointers[0]);
		unset($ids);

		$this->projects_categories_tree = $tree->subcategories;
		$this->all_projects_categories = $pointers;	
	}
}