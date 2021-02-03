<?PHP
require_once('api/Turbo.php');

class SettingsAdmin extends Turbo
{	
	private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/turbo/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/turbo/.htaccess';
		

		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);
 
 		if($this->request->method('POST'))
		{
			$this->settings->update('site_name', $this->request->post('site_name'));
			$this->settings->update('company_name', $this->request->post('company_name'));
			$this->settings->date_format = $this->request->post('date_format');
			$this->settings->admin_email = $this->request->post('admin_email');
            $this->settings->site_work = $this->request->post('site_work');
			$this->settings->lang = $this->request->post('manager_lang');
            
            $this->settings->captcha_project = $this->request->post('captcha_project', 'boolean');
            $this->settings->captcha_post = $this->request->post('captcha_post', 'boolean');
			$this->settings->captcha_article = $this->request->post('captcha_article', 'boolean');
            $this->settings->captcha_register  = $this->request->post('captcha_register', 'boolean');
            $this->settings->captcha_feedback  = $this->request->post('captcha_feedback', 'boolean');
            $this->settings->captcha_callback  = $this->request->post('captcha_callback', 'boolean');
			
			$this->settings->comments_tree_blog = $this->request->post('comments_tree_blog');
			$this->settings->comments_tree_articles = $this->request->post('comments_tree_articles');
			
			$this->settings->comment_email = $this->request->post('comment_email');
			$this->settings->notify_from_email = $this->request->post('notify_from_email');
			$this->settings->update('notify_from_name', $this->request->post('notify_from_name'));
			$this->settings->email_lang = $this->request->post('email_lang');
			
			$this->settings->projects_num = $this->request->post('projects_num');
			$this->settings->projects_num_admin = $this->request->post('projects_num_admin');
			$this->settings->articles_num = $this->request->post('articles_num');
			$this->settings->articles_num_admin = $this->request->post('articles_num_admin');
			$this->settings->blog_num = $this->request->post('blog_num');
			$this->settings->blog_num_admin = $this->request->post('blog_num_admin');
			
			$this->settings->smart_resize = $this->request->post('smart_resize','boolean');
			$this->settings->webp_support = $this->request->post('webp_support','boolean');
			
			if($this->request->post('category_count')==1)
				$this->settings->category_count = 1;
			else
				$this->settings->category_count = 0;
            
			// Водяной знак
			$clear_image_cache = false;
			$watermark = $this->request->files('watermark_file', 'tmp_name');
			if(!empty($watermark) && in_array(pathinfo($this->request->files('watermark_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
			{
				if(@move_uploaded_file($watermark, $this->config->root_dir.$this->config->watermark_file))
					$clear_image_cache = true;
				else
					$this->design->assign('message_error', 'watermark_is_not_writable');
			}
			
			if($this->settings->watermark_offset_x != $this->request->post('watermark_offset_x'))
			{
				$this->settings->watermark_offset_x = $this->request->post('watermark_offset_x');
				$clear_image_cache = true;
			}
			if($this->settings->watermark_offset_y != $this->request->post('watermark_offset_y'))
			{
				$this->settings->watermark_offset_y = $this->request->post('watermark_offset_y');
				$clear_image_cache = true;
			}
			if($this->settings->watermark_transparency != $this->request->post('watermark_transparency'))
			{
				$this->settings->watermark_transparency = $this->request->post('watermark_transparency');
				$clear_image_cache = true;
			}
			if($this->settings->images_sharpen != $this->request->post('images_sharpen'))
			{
				$this->settings->images_sharpen = $this->request->post('images_sharpen');
				$clear_image_cache = true;
			}
			
			// Удаление заресайзеных изображений
			if($clear_image_cache)
			{
				$dir = $this->config->resized_images_dir;
				if($handle = opendir($dir))
				{
					while(false !== ($file = readdir($handle)))
					{
						if($file != "." && $file != "..")
						{
							@unlink($dir."/".$file);
						}
					}
					closedir($handle);
				}			
			}			
			$this->design->assign('message_success', 'saved');
		}
        
        $btr_languages = array();
        foreach ($this->languages->lang_list() as $label=>$l) {
            if (file_exists("turbo/lang/".$label.".php")) {
                $btr_languages[$l->name] = $l->label;
            }
        }
        $this->design->assign('btr_languages', $btr_languages);
 	  	
        return $this->design->fetch('settings.tpl');
	}
	
}