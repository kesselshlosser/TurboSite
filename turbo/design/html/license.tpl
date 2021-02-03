{$meta_title = 'Лицензия' scope=global}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                Лицензия
			</div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" target="_blank" href="http://check.turbo-cms.com?domain={$smarty.server.HTTP_HOST|escape}">
					<i class="fa fa-link"></i>
					<span>Проверить лицензию</span>
				</a>
			</div>
		</div>
	</div>
</div>

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
	
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {if $license->valid}
						<div class="text_success">
							Лицензия действительна {if $license->expiration != '*'}до {$license->expiration}{/if} для домен{$license->domains|count|plural:'а':'ов'} {foreach $license->domains as $d}{$d}{if !$d@last}, {/if}{/foreach}
						</div>
					{else}
						<div class="text_warning">
							Лицензия недействительна
						</div>
					{/if}
					<div class="toggle_arrow_wrap fn_toggle_card text-primary">
						<a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
					</div>
				</div>
				<div class="toggle_body_wrap on fn_card">
					<div class="row">
						<div class="col-md-12 mb-h">
							<textarea name="license" class="form-control turbo_textarea mb-h" rows="5">{$config->license|escape}</textarea>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 col-md-12 ">
							<button type="submit" class="btn btn_small btn_green float-md-right">
								{include file='svg_icon.tpl' svgId='checked'}
								<span>Применить</span>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>