{* Title *}
{$meta_title=$btr->users_users scope=global}

{if $users_count>0}
    <div class="row">
        <progress id="progressbar" class="progress progress-xs progress-info mt-0" style="display: none" value="0" max="100"></progress>
    </div>
{/if}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">
            {if $keyword && $users_count>0}
               {$btr->users_users|escape} ({$users_count})
            {elseif $users_count>0}
                {$btr->users_users|escape} ({$users_count})
			{else}
				{$btr->users_no|escape}
            {/if}
            {if $users_count>0}
                <div class="export_block export_users hint-bottom-middle-t-info-s-small-mobile  hint-anim" data-hint="{$btr->users_export|escape}">
                    <span class="fn_start_export fa fa-file-excel-o"></span>
                </div>
            {/if}
        </div>
    </div>

    <div class="col-md-12 col-lg-5 col-xs-12 float-xs-right">
        <div class="boxed_search">
            <form class="search" method="get">
                <input type="hidden" name="module" value="UsersAdmin">
                <div class="input-group">

                    <input name="keyword" class="form-control" placeholder="{$btr->users_search|escape}" type="text" value="{$keyword|escape}" >

                    <span class="input-group-btn">
                        <button type="submit" class="btn btn_green"><i class="fa fa-search"></i> <span class="hidden-md-down"></span></button>
                    </span>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="boxed fn_toggle_wrap">
   {if $users}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <form class="fn_form_list" method="post">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">

                    <div class="users_wrap turbo_list projects_list fn_sort_list">
                        <div class="turbo_list_head">
                            <div class="turbo_list_heading turbo_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                                <label class="turbo_ckeckbox" for="check_all_1"></label>
                            </div>
                            <div class="turbo_list_heading turbo_list_users_name">
                                <span>{$btr->general_name|escape}</span>
                                <a href="{url sort=name}" {if $sort == 'name'}class="selected"{/if}>{include file='svg_icon.tpl' svgId='sorts'}</a>
                            </div>
                            <div class="turbo_list_heading turbo_list_users_email">
                                <span>Email</span>
                                <a href="{url sort=email}" {if $sort == 'email'}class="selected"{/if}>{include file='svg_icon.tpl' svgId='sorts'}</a>
                            </div>
                            <div class="turbo_list_heading turbo_list_users_date">
                                <span>{$btr->general_registration_date|escape}</span>
                                <a href="{url sort=date}" {if $sort == 'date'}class="selected"{/if}>{include file='svg_icon.tpl' svgId='sorts'}</a>
                            </div>
                            <div class="turbo_list_heading turbo_list_users_group"></div>
                            
                             <div class="turbo_list_heading turbo_list_count"></div>
                            
                            <div class="turbo_list_heading turbo_list_status">{$btr->general_activities|escape}</div>
                            <div class="turbo_list_heading turbo_list_close"></div>
                        </div>
                        <div class="turbo_list_body sortable">
                            {foreach $users as $user}
                                <div class="fn_row turbo_list_body_item fn_sort_item body_narrow">
                                    <div class="turbo_list_row narrow">
                                        <div class="turbo_list_boding turbo_list_check">
                                            <input class="hidden_check" type="checkbox" id="id_{$user->id}" name="check[]" value="{$user->id}"/>
                                            <label class="turbo_ckeckbox" for="id_{$user->id}"></label>
                                        </div>

                                        <div class="turbo_list_boding turbo_list_users_name">
                                            <a href="{url module=UserAdmin id=$user->id}">
                                                {$user->name|escape}
                                            </a>
                                        </div>

                                        <div class="turbo_list_boding turbo_list_users_email">
                                            <a href="mailto:{$user->name|escape}<{$user->email|escape}>">
                                                {$user->email|escape}
                                            </a>
                                        </div>

                                        <div class="turbo_list_boding turbo_list_users_date">
                                            {$user->created|date} | {$user->created|time}
                                        </div>

                                        <div class="turbo_list_boding turbo_list_users_group"></div>

                                        <div class="turbo_list_boding turbo_list_count"></div>

                                        <div class="turbo_list_boding turbo_list_status">
                                             {*visible*}
                                            <label class="switch switch-default">
                                                <input class="switch-input fn_ajax_action {if $user->enabled}fn_active_class{/if}" data-module="user" data-action="enabled" data-id="{$user->id}" name="enabled" value="1" type="checkbox"  {if $user->enabled}checked=""{/if}/>
                                                <span class="switch-label"></span>
                                                <span class="switch-handle"></span>
                                            </label>
                                        </div>
                                        
                                        <div class="turbo_list_boding turbo_list_close">
                                            <button data-hint="{$btr->users_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                        <div class="turbo_list_footer fn_action_block">
                            <div class="turbo_list_foot_left">
                                <div class="turbo_list_heading turbo_list_check">
                                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                    <label class="turbo_ckeckbox" for="check_all_2"></label>
                                </div>
                                <div class="turbo_list_option">
                                    <select name="action" class="selectpicker fn_user_select">
                                        <option value="0">{$btr->general_select_action|escape}</option>
                                        <option value="enable">{$btr->general_do_enable|escape}</option>
                                        <option value="disable">{$btr->general_do_disable|escape}</option>
                                        <option value="delete">{$btr->general_delete|escape}</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn_small btn_green">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                {include file='pagination.tpl'}
            </div>
        </div>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->users_no|escape}</div>
        </div>
    {/if}
</div>


<script src="{$config->root_url}/turbo/design/js/piecon/piecon.js"></script>
<script>
    var group_id='{$group_id|escape}';
    var keyword='{$keyword|escape}';
    var sort='{$sort|escape}';
</script>

{literal}
<script>
$(function() {

    $(document).on('change','select.fn_user_select',function(){
        var elem = $(this).find('option:selected').val();
        $('.fn_hide_block').addClass('hidden');
        if($('#'+elem).size()>0){
            $('#'+elem).removeClass('hidden');
        }
    });

    // On document load
    $(document).on('click','.fn_start_export',function(){
        Piecon.setOptions({fallback: 'force'});
        Piecon.setProgress(0);
        var progress_item = $("#progressbar"); //specify an element selector with animation
        progress_item.show();
        do_export('',progress_item);
    });

    function do_export(page,progress) {
        page = typeof(page) != 'undefined' ? page : 1;
        $.ajax({
            url: "ajax/export_users.php",
            data: {page:page, group_id:group_id, keyword:keyword, sort:sort},
            dataType: 'json',
            success: function(data){
                if(data && !data.end) {
                    Piecon.setProgress(Math.round(100*data.page/data.totalpages));
                    progress.attr('value',100*data.page/data.totalpages);
                    do_export(data.page*1+1,progress);
                }
                else {
                    Piecon.setProgress(100);
                    progress.attr('value','100');
                    window.location.href = 'files/export_users/users.csv';
                    progress.fadeOut(500);
                }
            },
            error:function(xhr, status, errorThrown) {
                alert(errorThrown+'\n'+xhr.responseText);
            }
        });
    }
});
</script>
{/literal}