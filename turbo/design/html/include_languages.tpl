{*id мультиязычных сущностей сайта*}
{if $project->id}
    {$id = $project->id}
{elseif $category->id}
    {$id = $category->id}
{elseif $user->id}
    {$id = $user->id}
{elseif $page->id}
    {$id = $page->id}
{elseif $post->id}
    {$id = $post->id}
{elseif $banner->id}
    {$id = $banner->id}
{elseif $banners_image->id}
    {$id = $banners_image->id}
{elseif $m->id && $smarty.get.module == "ManagerAdmin"}
    {$id = $m->id}
{elseif $language->id}
    {$id = $language->id}
{elseif $translation->id}
    {$id = $translation->id}
{elseif $menu->id}
    {$id = $menu->id}
{/if}

{*Список языков*}
{if $languages}
    {foreach $languages as $lang}
        <a class="flag flag_{$lang->id} {if $lang->id == $lang_id}focus{/if} hint-bottom-middle-t-info-s-small-mobile hint-anim" data-hint="{$lang->name|escape}" href="{url lang_id=$lang->id id=$id}" data-label="{$lang->label}">
            <img src="../files/lang/{$lang->label}.png" width="32px;" height="32px;">
        </a>
    {/foreach}
{/if}
