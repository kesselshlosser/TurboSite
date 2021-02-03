{* Project page *}

{* Canonical page address *}
{$canonical="/project/{$project->url}" scope=global}

<div class="row">
	<div class="mobile-offcanvas col-lg-3 bg-white" id="sidebar">
		<div class="offcanvas-header my-4">  
			<button class="btn btn-danger btn-close float-right"> &times {$lang->close}</button>
			<h5 class="py-2">{$lang->catalog}</h5>
		</div>
		<!-- Search -->
		<form class="input-group my-4" action="{$lang_link}projects">
			<input class="form-control" type="text" name="keyword" autocomplete="off" value="{$keyword|escape}" placeholder="{$lang->search_project}"/>
			<div class="input-group-append">
				<button class="btn btn-success" type="submit"><i class="fa fa-search"></i></button>
			</div>    
		</form>
		<!-- Search (The End)-->
		<div class="list-group my-4">
			{foreach $projects_categories as $c}
			{if $c->visible}
			<span class="hidden-sm-down list-group-item {if $projects_category->id == $c->id}bg-primary{/if}">
				<a data-projects-category="{$c->id}" href="{$lang_link}projects/{$c->url}">
					{$c->name|escape}
				</a>
				{if $c->subcategories}
				<a data-toggle="collapse" data-parent="#sidebar" href="#menu{$c->id}">
					<i class="fa fa-caret-down"></i>
				</a>
				{/if}
			</span> 
			{if $c->subcategories}
			<div class="collapse cat {if in_array($projects_category->id, $c->children)}show{/if}" id="menu{$c->id}">
				{foreach $c->subcategories as $cat}
				{if $c->visible}
				<span class="hidden-sm-down list-group-item {if $projects_category->id == $cat->id}bg-primary{/if}">
					<a data-projects-category="{$cat->id}" href="{$lang_link}projects/{$cat->url}">
						{$cat->name|escape}
					</a>
					{if $cat->subcategories}
					<a data-toggle="collapse" aria-expanded="false" href="#menusub{$cat->id}">
						<i class="fa fa-caret-down"></i>
					</a>
					{/if}
				</span> 
				{if $cat->subcategories}
				<div class="collapse cat3 {if in_array($projects_category->id, $cat->children)}show{/if}" id="menusub{$cat->id}">
					{foreach $cat->subcategories as $cat3}
					{if $cat3->visible}
					<a data-projects-category="{$cat3->id}" href="{$lang_link}projects/{$cat3->url}" class="list-group-item {if $projects_category->id == $cat3->id}bg-primary text-white{/if}" data-parent="#menusub{$cat->id}">{$cat3->name|escape}</a>
					{/if}
					{/foreach}
				</div>
				{/if}
				{/if}
				{/foreach}
			</div>
			{/if}
			{/if}
			{/foreach}
		</div>
		{* Last comments *}
		{get_comments var=last_comments}
		{if $last_comments}
		<div class="card my-4">
			<h5 class="card-header">{$lang->comments_global}</h5>
			<div class="card-body">
				{get_comments var=last_comments limit=3 type='project'}
				{if $last_comments}
				{foreach $last_comments as $comment}
				<h5 class="card-title">{$comment->name}</h5>
				<p class="card-text"><small class="text-muted">{$comment->date|date}  в  {$comment->date|time}</small></p>
				<p class="card-text">{$comment->text|strip_tags|truncate:150}</p>
				<p>
					<a href="{$lang_link}project/{$comment->url}#comment_{$comment->id}" class="card-link"><small>{$comment->project}</small></a>
				</p>
				<hr>
				{/foreach}
				{/if}
				{get_comments var=last_comments limit=3 type='article'}
				{if $last_comments}
				{foreach $last_comments as $comment}
				<h5 class="card-title">{$comment->name}</h5>
				<p class="card-text"><small class="text-muted">{$comment->date|date}  в  {$comment->date|time}</small></p>
				<p class="card-text">{$comment->text|strip_tags|truncate:150}</p>
				<p>
					<a href="{$lang_link}article/{$comment->url}#comment_{$comment->id}" class="card-link"><small>{$comment->article}</small></a>
				</p>
				<hr>
				{/foreach}
				{/if}
				{get_comments var=last_comments limit=3 type='blog'}
				{if $last_comments}
				{foreach $last_comments as $comment}
				<h5 class="card-title">{$comment->name}</h5>
				<p class="card-text"><small class="text-muted">{$comment->date|date}  в  {$comment->date|time}</small></p>
				<p class="card-text">{$comment->text|strip_tags|truncate:150}</p>
				<p>
					<a href="{$lang_link}blog/{$comment->url}#comment_{$comment->id}" class="card-link"><small>{$comment->post}</small></a>
				</p>
				<hr>
				{/foreach}
				{/if}
			</div>
		</div>
		{/if}
	</div>
	<div class="col-lg-9 order-lg-2 order-1">
		<nav class="navbar navbar-expand-lg navbar-dark bg-primary d-lg-none mt-4 rounded">
			<a class="navbar-brand" href="#">{$lang->catalog}</a>
			<button class="navbar-toggler" type="button" data-trigger="#sidebar">
				<span class="navbar-toggler-icon"></span>
			</button>
		</nav>
    <!-- Breadcrumbs -->
    {$level = 1}
	<nav class="mt-4" aria-label="breadcrumb">
		<ol itemscope itemtype="https://schema.org/BreadcrumbList" class="breadcrumb  bg-light">
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
				<a itemprop="item" href="{$lang_link}"><span itemprop="name">{$lang->home}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
				<a itemprop="item" href="{$lang_link}projects"><span itemprop="name">{$lang->global_projects}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			{foreach from=$projects_category->path item=cat}
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
				<a itemprop="item" href="{$lang_link}projects/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			{/foreach}
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item active">
				<a itemprop="item" href="{$lang_link}"><span itemprop="name">{$project->name|escape}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
		</ol>
	</nav>
	<h1 data-project="{$project->id}" class="my-4">{$project->name|escape}</h1>
    <!-- Portfolio Item Row -->
    <div class="row">
		<div class="col-md-8">
			<div id="carouselExampleIndicators" class="carousel slide my-4" data-ride="carousel">
				<div class="carousel-inner" role="listbox">
					{foreach $project->images as $i=>$image name=foo}
					<div class="carousel-item image {if $smarty.foreach.foo.first}active{/if}">
						<a data-fancybox="gallery" href="{$image->filename|resize:800:800}">
							<img src="{$image->filename|resize:750:500}" alt="{$project->name|escape}">
							<span class="icon-focus"><i class="fa fa-search-plus"></i></span>
						</a>
					</div>
					{/foreach}
				</div>
			</div>
			{if $project->images|count>1}
			<span class="d-sm-none d-md-block d-none">
				<div class="row text-center text-lg-left">
					{foreach $project->images as $i=>$image name=images}
					<div class="col-lg-3 col-md-4 col-xs-6 mb-4">
						<a href="#" data-target="#carouselExampleIndicators" data-slide-to="{$smarty.foreach.images.index}" class="d-block text-center img-thumbnail">
							<img class="img-fluid thumbnail" src="{$image->filename|resize:95:95}" alt="{$project->name|escape}">
						</a>
					</div>
					{/foreach}
				</div>
			</span>
			{/if}
		</div>
		<div class="col-md-4">
			{if $project->annotation}
			<h3 class="my-3">{$lang->project_annotation}</h3>
			<p>{$project->annotation}</p>
			{/if}
			<h3 class="my-3">{$lang->project_details}</h3>
			<ul>
				<li>{$lang->date}: {$post->date|date}</li>
				{if $category->name}<li>{$lang->category}: {$category->name|escape}</li>{/if}
				{if $project->site}<li>{$lang->site}: {$project->site|escape}</li>{/if}
				{if $project->client}<li>{$lang->customer}: {$project->client|escape}</li>{/if}
			</ul>
		</div>
	</div>
	<!-- /.row -->
	{if $prev_project || $next_project}
	<!-- Neighboring projects /-->
	<hr>
	<div class="row">
		<div class="col-lg-6 col-sm-6 col-6 text-left">
			{if $prev_project}
				<a href="project/{$prev_project->url}">←&nbsp;{$prev_project->name|escape}</a>
			{/if}
		</div>
		<div class="col-lg-6 col-sm-6 col-6 text-right">
			{if $next_project}
				<a href="project/{$next_project->url}">{$next_project->name|escape}&nbsp;→</a>
			{/if}
		</div>
	</div>
	<hr>
	{/if}
	<!-- /.row -->
	<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
		<li class="nav-item">
			<a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">{$lang->description}</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="contact-tab" data-toggle="tab" href="#contact" role="tab" aria-controls="contact" aria-selected="false">{$lang->comments_global} ({$comments|count})</a>
		</li>
	</ul>
	<div class="tab-content mt-4" id="myTabContent">
		<div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">{$project->text}</div>
		<div class="tab-pane fade" id="contact" role="tabpanel" aria-labelledby="contact-tab">
			<!-- Comments Form -->
			{if $comments}
			<span itemprop="review" itemscope itemtype="http://schema.org/Review">
			<!-- Single Comment-->
			{foreach $comments as $comment}
			<meta itemprop="datePublished" content="{$comment->date|date}">
			<a name="comment_{$comment->id}"></a>
			<p><span itemprop="name">{$comment->text|escape|nl2br}</span></p>
			<small class="text-muted"><b><span itemprop="author">{$comment->name|escape}</span></b> {$comment->date|date} в {$comment->date|time} {if !$comment->approved}<span class="text-danger">{$lang->awaiting_moderation}</span>{/if}</small>
			<hr>
			{/foreach}
			<!-- Single Comment (The End)-->
			{else}
			<p>{$lang->no_comments}</p>
			</span>
			{/if}
			<a class="btn btn-success mb-4" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">{$lang->comment_on}</a>
			<div class="collapse" id="collapseExample">
				{if $error}
				<div class="alert alert-danger" role="alert">
					{if $error=='captcha'}
						{$lang->captcha_entered_incorrectly}
					{elseif $error=='empty_name'}
						{$lang->enter_your_name}
					{elseif $error=='empty_comment'}
						{$lang->enter_a_comment}
					{/if}
				</div>
				{/if}
				<form class="form-horizontal mt-4" id="loginForm" role="form" method="post">
					<div class="form-group">
						<label for="comment">{$lang->comment}</label>
						<textarea class="form-control" rows="4" name="text" placeholder="{$lang->enter_a_comment}" data-format=".+" required="" data-notice="{$lang->enter_a_comment}">{$comment_text}</textarea>
						<div class="invalid-feedback">{$lang->enter_a_comment}</div>
					</div>
					<div class="form-group">
						<label for="comment_name">{$lang->name}</label>
						<input class="form-control" type="text" id="comment_name" name="name" placeholder="{$lang->enter_your_name}" required="" value="{$comment_name}" data-format=".+" data-notice="{$lang->enter_your_name}"/>
						<div class="invalid-feedback">{$lang->enter_your_name}</div>
					</div>
					{if $settings->captcha_project}
					<div class="form-row mt-4">
						<div class="form-group col-md-2">
							{get_captcha var="captcha_project"}
							<div class="secret_number">{$captcha_project[0]|escape} + ? =  {$captcha_project[1]|escape}</div> 
						</div>
						<div class="form-group col-md-10">
							<input class="form-control" type="text" autocomplete="off" name="captcha_code" required="" placeholder="{$lang->enter_captcha}" value="" data-format=".+" data-notice="{$lang->enter_captcha}"/>
							<div class="invalid-feedback">{$lang->enter_captcha}</div>
						</div>
					</div>
					{/if}
					<div class="form-group">
						<div class="col-sm-offset-2">
							<input class="btn btn-primary" type="submit" id="btnLogin" name="comment" value="{$lang->send}" />
						</div>
					</div>
				</form>	
			</div>
		</div>
	</div>
	{if $related_projects}
	<!-- Related Projects Row -->
	<h3 class="my-4">{$lang->related_projects}</h3>
	<div class="row">
		{foreach $related_projects as $related_project}
			<div class="col-md-6 col-lg-4 mb-5">
				<div class="card h-100">
					{if $related_project->image}
					<img class="card-img-top" src="{$related_project->image->filename|resize:750:300}" alt="{$related_project->name|escape}">
					{else}
					<span class="text-center mt-4">
						<img style="width: 210px; height: 210px;" src="design/{$settings->theme|escape}/images/no-photo.svg" alt="{$related_project->name|escape}"/>
					</span>	
					{/if}
					<div class="card-body">
						<h5 class="card-title"><a data-project="{$related_project->id}" href="{$lang_link}project/{$related_project->url}">{$related_project->name|escape}</a></h5>
					</div>
				</div>
			</div>
		{/foreach}
	</div>
	<!-- /.row -->
	{/if}
</div>
</div>
