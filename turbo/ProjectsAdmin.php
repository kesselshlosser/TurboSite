<?php

/**
 * Turbo CMS
 *
 * @author 		Turbo CMS
 * @link 		https://turbo-cms.com
 *
 */
 
require_once('api/Turbo.php');

class ProjectsAdmin extends Turbo
{
	public function fetch()
	{
		// Обработка действий
		if($this->request->method('post'))
		{
		
			// Сортировка
			$positions = $this->request->post('positions'); 		
				$ids = array_keys($positions);
			sort($positions);
			$positions = array_reverse($positions);
			foreach($positions as $i=>$position)
				$this->projects->update_project($ids[$i], array('position'=>$position));		
		
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
					$this->projects->update_project($ids, array('visible'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->projects->update_project($ids, array('visible'=>1));	      
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->projects->delete_project($id);    
			        break;
			    }
			}				
		}

		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
		$filter['limit'] = $this->settings->projects_num_admin;

		// Категории
		$projects_categories = $this->projects_categories->get_projects_categories_tree();
		$this->design->assign('projects_categories', $projects_categories);
		
		// Текущая категория
		$category_id = $this->request->get('category_id', 'integer');
        $category = $this->projects_categories->get_projects_category($category_id);
        $this->design->assign('category', $category); 
		if($category_id && $category)
	  		$filter['category_id'] = $category->children;
      
        // Текущий фильтр
		if($f = $this->request->get('filter', 'string'))
		{
			
			if($f == 'visible')
				$filter['visible'] = 1; 
			elseif($f == 'hidden')
				$filter['visible'] = 0; 
		   $this->design->assign('filter', $f);
		}

		// Поиск
		$keyword = $this->request->get('keyword', 'string');
		if(!empty($keyword))
		{
			$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}		
		
		$projects_count = $this->projects->count_projects($filter);
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $projects_count;	
		
		$projects = $this->projects->get_projects($filter);
		$this->design->assign('projects_count', $projects_count);
		
		$this->design->assign('pages_count', ceil($projects_count/$filter['limit']));
		$this->design->assign('current_page', $filter['page']);
      
      $projects = array();
		foreach($this->projects->get_projects($filter) as $p)
			$projects[$p->id] = $p;
	 	
	
		if(!empty($projects))
		{
		  	
			// Проекты 
			$projects_ids = array_keys($projects);
			foreach($projects as &$project)
			{
				$project->images = array();
			}
	
			$images = $this->projects->get_images(array('project_id'=>$projects_ids));
			foreach($images as $image)
				$projects[$image->project_id]->images[$image->id] = $image;
		}
		
		$this->design->assign('projects', $projects);
		return $this->design->fetch('projects.tpl');
	}
}
