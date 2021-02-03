<div class="mobile-offcanvas col-lg-3 bg-white" id="sidebar">
	<div class="offcanvas-header my-4">  
		<button class="btn btn-danger btn-close float-right"> &times {$lang->close}</button>
		<h5 class="py-2">{$lang->catalog}</h5>
	</div>
	{if $module=='ArticlesView' || $module=='ArticleView'}
	<!-- Search -->
	<form class="input-group my-4" action="{$lang_link}articles">
		<input class="form-control" type="text" name="keyword" autocomplete="off" value="{$keyword|escape}" placeholder="{$lang->search_article}"/>
		<div class="input-group-append">
			<button class="btn btn-success" type="submit"><i class="fa fa-search"></i></button>
		</div>    
	</form>
	<!-- Search (The End)-->
	<div class="list-group my-4">
		{foreach $articles_categories as $c}
		{if $c->visible}
		<span class="hidden-sm-down list-group-item {if $articles_category->id == $c->id}bg-primary{/if}">
			<a data-articles-category="{$c->id}" href="{$lang_link}articles/{$c->url}">
				{$c->name|escape}
			</a>
			{if $c->subcategories}
			<a data-toggle="collapse" data-parent="#sidebar" href="#menu{$c->id}">
				<i class="fa fa-caret-down"></i>
			</a>
			{/if}
		</span> 
		{if $c->subcategories}
		<div class="collapse cat {if in_array($articles_category->id, $c->children)}show{/if}" id="menu{$c->id}">
			{foreach $c->subcategories as $cat}
			{if $c->visible}
			<span class="hidden-sm-down list-group-item {if $articles_category->id == $cat->id}bg-primary{/if}">
				<a data-articles-category="{$cat->id}" href="{$lang_link}articles/{$cat->url}">
					{$cat->name|escape}
				</a>
				{if $cat->subcategories}
				<a data-toggle="collapse" aria-expanded="false" href="#menusub{$cat->id}">
					<i class="fa fa-caret-down"></i>
				</a>
				{/if}
			</span> 
			{if $cat->subcategories}
			<div class="collapse cat3 {if in_array($articles_category->id, $cat->children)}show{/if}" id="menusub{$cat->id}">
				{foreach $cat->subcategories as $cat3}
				{if $cat3->visible}
				<a data-articles-category="{$cat3->id}" href="{$lang_link}articles/{$cat3->url}" class="list-group-item {if $articles_category->id == $cat3->id}bg-primary text-white{/if}" data-parent="#menusub{$cat->id}">{$cat3->name|escape}</a>
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
	{/if}
	{if $module=='BlogView'}
	<!-- Search-->
	<form class="input-group my-4" action="{$lang_link}blog">
		<input class="form-control" type="text" name="keyword" autocomplete="off" value="{$keyword|escape}" placeholder="{$lang->search_blog}"/>
		<div class="input-group-append">
			<button class="btn btn-success" type="submit"><i class="fa fa-search"></i></button>
		</div>    
	</form>
	{/if}
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