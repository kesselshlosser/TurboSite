<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Этот класс использует шаблон index.tpl,
 * который содержит всю страницу кроме центрального блока
 * По get-параметру module мы определяем что сожержится в центральном блоке
 *
 */

require_once('View.php');

class IndexView extends View
{	
	public $modules_dir = 'view/';

	public function __construct()
	{
		parent::__construct();
	}

	/**
	 *
	 * Отображение
	 *
	 */
	function fetch()
	{
        // E-mail подписка
        if($this->request->method('post') && $this->request->post('subscribe'))
		{
            $email = $this->request->post('subscribe_email');
            $this->db->query("select count(id) as cnt from __subscribes where email=?", $email);
            $cnt = $this->db->result('cnt');
            if (empty($email)) {
                $this->design->assign('subscribe_error', 'empty_email');
            } elseif ($cnt > 0) {
                $this->design->assign('subscribe_error', 'email_exist');
            } else {
                $this->db->query("insert into __subscribes set email=?, date = NOW()", $email);
                $this->design->assign('subscribe_success', '1');
            }
        }
		
        // Обратный звонок
        if($this->request->method('post') && $this->request->post('callback'))
        {
                $callback = new stdClass();
				$callback->name         = $this->request->post('name');
                $callback->phone        = $this->request->post('phone');
				//$callback->email        = $this->request->post('email');
                $captcha_code           = $this->request->post('captcha_code', 'string');
                //$callback->message      = $this->request->post('message');
                //$callback->message      = "___";
                //$callback->name         = "no_name";
                
                $this->design->assign('callname',  $callback->name);
                $this->design->assign('callphone', $callback->phone);
				//$this->design->assign('callemail', $callback->email);
                //$this->design->assign('callmessage', $callback->message);
                
                if(empty($callback->name)){
                    $this->design->assign('call_error', 'empty_name');
                }elseif (empty($callback->phone)) {
                    $this->design->assign('call_error', 'empty_phone');
                }elseif($this->settings->captcha_callback && ($_SESSION['captcha_callback'] != $captcha_code || empty($captcha_code))){
                    $this->design->assign('call_error', 'captcha'); 
                }else{
                $this->design->assign('call_sent', true);				
                $callback_id = $this->callbacks->add_callback($callback);				
                // Отправляем email
                $this->notify->email_callback_admin($callback_id);
				}
        }
		
		if (isset($_SESSION['admin'])){
            // Перевод админки
            $backend_translations = $this->backend_translations;
            $file = "turbo/lang/".$this->settings->lang.".php";
            if (!file_exists($file)) {
                foreach (glob("turbo/lang/??.php") as $f) {
                    $file = "turbo/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                    break;
                }
            }
            require_once($file);
            $this->design->assign('btr', $backend_translations);
            $this->design->assign('admintooltip', $this->design->fetch($this->config->root_dir.'turbo/design/html/admintooltip.tpl'));
        }
        
		// Категории проектов
		$this->design->assign('projects_categories', $this->projects_categories->get_projects_categories_tree());	  
		
		// Категории статей
		$this->design->assign('articles_categories', $this->articles_categories->get_articles_categories_tree());
		
		// Страницы
		$pages = $this->pages->get_pages_tree(array('visible'=>1));		
		$this->design->assign('pages', $pages);
		
		$is_mobile = $this->design->is_mobile();
        $is_tablet = $this->design->is_tablet();
        $this->design->assign('is_mobile',$is_mobile);
        $this->design->assign('is_tablet',$is_tablet);
							
		// Текущий модуль (для отображения центрального блока)
		$module = $this->request->get('module', 'string');
		$module = preg_replace("/[^A-Za-z0-9]+/", "", $module);

		// Если не задан - берем из настроек
		if(empty($module))
			return false;
		//$module = $this->settings->main_module;

		// Создаем соответствующий класс
		if (is_file($this->modules_dir."$module.php"))
		{
				include_once($this->modules_dir."$module.php");
				if (class_exists($module))
				{
					$this->main = new $module($this);
				} else return false;
		} else return false;

		// Создаем основной блок страницы
		if (!$content = $this->main->fetch())
		{
			return false;
		}		

		// Передаем основной блок в шаблон
		$this->design->assign('content', $content);		
		
		// Передаем название модуля в шаблон, это может пригодиться
		$this->design->assign('module', $module);
				
		// Создаем текущую обертку сайта (обычно index.tpl)
		$wrapper = $this->design->get_var('wrapper');
		if(is_null($wrapper))
			$wrapper = 'index.tpl';
        
        if(empty($_SESSION['admin'])) {
            if ($this->settings->site_work == "off") {
                header('HTTP/1.0 503 Service Temporarily Unavailable');
                header('Status: 503 Service Temporarily Unavailable');
                header('Retry-After: 300');//300 seconds
                return $this->design->fetch('tech.tpl');
            }
        }
			
		if(!empty($wrapper))
			return $this->body = $this->design->fetch($wrapper);
		else
			return $this->body = $content;

	}
}