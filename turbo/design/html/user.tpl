{if $user->id}
    {$meta_title = $user->name|escape scope=global}
{/if}

<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->user_user|escape} {$user->name|escape} 
            </div>
        </div>
    </div>
    <div class="col-md-12 col-lg-12 col-sm-12 float-xs-right"></div>
</div>

{if $message_success}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_success">
            <div class="heading_box">
                {if $message_success=='updated'}
                    {$btr->user_updated|escape}
                {else}
                    {$message_success|escape}
                {/if}
                {if $smarty.get.return}
                <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                    {include file='svg_icon.tpl' svgId='return'}
                    <span>{$btr->general_back|escape}</span>
                </a>
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

{if $message_error}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_warning">
            <div class="heading_box">
                {if $message_error=='login_exists'}
                    {$btr->user_already_registered|escape}
                {elseif $message_error=='empty_name'}
                    {$btr->user_name|escape}
                {elseif $message_error=='empty_email'}
                    {$btr->user_email|escape}
                {else}
                    {$message_error|escape}
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

<form method="post" enctype="multipart/form-data" class="clearfix">
    <input type="hidden" name="session_id" value="{$smarty.session.id}">
    
    <div class="row">
        <div class="col-xs-12 ">
            <div class="boxed match_matchHeight_true">
                <div class="row d_flex">
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->index_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control" name="name" type="text" value="{$user->name|escape}"/>
                            <input name="id" type="hidden" value="{$user->id|escape}"/>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item">
                                <div class="turbo_switch clearfix">
                                    <label class="switch_label">{$btr->general_enable|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="enabled" value='1' type="checkbox" id="visible_checkbox" {if $user->enabled}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->user_options|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="mb-1">
                                <div class="heading_label">E-mail</div>
                                <div>
                                    <input name="email" class="form-control" type="text" value="{$user->email|escape}" />
                                </div>
                            </div>
                             <div class="mb-1">
                                <div class="heading_label">{$btr->general_phone|escape}</div>
                                <div>
                                    <input class="form-control mb-h" name="phone" type="text" value="{$user->phone|escape}"/>
                                    <input name="id" type="hidden" value="{$user->id|escape}"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="mb-1">
                                <div class="heading_label">{$btr->general_registration_date|escape}</div>
                                <div>
                                    <input name="" class="form-control" type="text" disabled value="{$user->created|date}" />
                                </div>
                            </div>
                            <div class="mb-1">
                                <div class="heading_label">{$btr->user_last_ip|escape}</div>
                                <div>
                                    <input name=""  class="form-control" type="text" disabled value="{$user->last_ip|escape}" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 col-md-12 mb-2">
            <button type="submit" class="btn btn_small btn_green float-md-right">
                {include file='svg_icon.tpl' svgId='checked'}
                <span>{$btr->general_apply|escape}</span>
            </button>
        </div>
    </div>
</form>