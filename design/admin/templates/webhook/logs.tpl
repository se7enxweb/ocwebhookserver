<div class="context-block">
    <div class="box-header">
        <div class="box-tc">
            <div class="box-ml">
                <div class="box-mr">
                    <div class="box-tl">
                        <div class="box-tr">
                            <h1 class="context-title">{'Webhook logs'|i18n( 'extension/ocwebhookserver' )}</h1>
                            <div class="header-mainline"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="box-ml">
    <div class="box-mr">
        <div class="box-content">
            <div class="context-toolbar">
                <div class="block">
                    <div class="left">
                        <p>
                            {switch match=$limit}
                            {case match=25}
                                <a href={'/user/preferences/set/webhooks_limit/10/'|ezurl} title="{'Show 10 items per page.'|i18n( 'design/admin/node/view/full' )}">10</a>
                                <span class="current">25</span>
                                <a href={'/user/preferences/set/webhooks_limit/50/'|ezurl} title="{'Show 50 items per page.'|i18n( 'design/admin/node/view/full' )}">50</a>
                            {/case}

                            {case match=50}
                                <a href={'/user/preferences/set/webhooks_limit/10/'|ezurl} title="{'Show 10 items per page.'|i18n( 'design/admin/node/view/full' )}">10</a>
                                <a href={'/user/preferences/set/webhooks_limit/25/'|ezurl} title="{'Show 25 items per page.'|i18n( 'design/admin/node/view/full' )}">25</a>
                                <span class="current">50</span>
                            {/case}

                            {case}
                                <span class="current">10</span>
                                <a href={'/user/preferences/set/webhooks_limit/25/'|ezurl} title="{'Show 25 items per page.'|i18n( 'design/admin/node/view/full' )}">25</a>
                                <a href={'/user/preferences/set/webhooks_limit/50/'|ezurl} title="{'Show 50 items per page.'|i18n( 'design/admin/node/view/full' )}">50</a>
                            {/case}

                            {/switch}
                        </p>
                    </div>
                </div>
            </div>
            <div class="block">
                {if $job_count|eq(0)}
                    {"No jobs"|i18n( 'extension/ocwebhookserver' )}
                {else}
                    <form method="post" action="{$uri|ezurl(no)}">
                        <table class="list" cellspacing="0">
                            <thead>
                            <tr>
                                <th width="1">{"ID"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Status"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Trigger"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Payload"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Created at"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Executed at"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Response code"|i18n( 'extension/ocwebhookserver' )}</th>
                                <th>{"Response headers/Error message"|i18n( 'extension/ocwebhookserver' )}</th>
                            </tr>
                            </thead>

                            <tbody>
                            {foreach $jobs as $job sequence array( 'bglight', 'bgdark' ) as $trClass}
                                <tr class="{$trClass}">
                                    <td>{$job.id|wash()}</td>
                                    <td>
                                        {if $job.execution_status|eq(0)}
                                            {"Pending"|i18n( 'extension/ocwebhookserver' )}
                                        {elseif $job.execution_status|eq(1)}
                                            {"Running"|i18n( 'extension/ocwebhookserver' )}
                                        {elseif $job.execution_status|eq(2)}
                                            {"Done"|i18n( 'extension/ocwebhookserver' )}
                                        {elseif $job.execution_status|eq(3)}
                                            {"Failed"|i18n( 'extension/ocwebhookserver' )}
                                        {/if}
                                    </td>
                                    <td>{$job.trigger.name|wash()}</td>
                                    <td><pre><code class="json">{$job.payload|wash()}</code></pre></td>
                                    <td>{$job.created_at|l10n( shortdatetime )}</td>
                                    <td>{if $job.executed_at|int()|gt(0)}{$job.executed_at|l10n( shortdatetime )}{/if}</td>
                                    <td>{$job.response_status|wash()}</td>
                                    <td><pre><code class="json">{$job.response_headers|wash()}</code></pre></td>
                                </tr>
                            {/foreach}
                            </tbody>
                        </table>
                    </form>
                {/if}
            </div>
            <div class="context-toolbar">
                {include name=navigator uri='design:navigator/google.tpl'
                         page_uri=$uri
                         item_count=$job_count
                         view_parameters=$view_parameters
                         item_limit=$limit}
            </div>
        </div>
    </div>
</div>

<div class="controlbar"><div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br"></div></div></div></div></div></div></div>

{literal}
<script>
    $(document).ready(function () {

        var library = {};
        library.json = {
            replacer: function(match, pIndent, pKey, pVal, pEnd) {
                var key = '<span class=json-key>';
                var val = '<span class=json-value>';
                var str = '<span class=json-string>';
                var r = pIndent || '';
                if (pKey)
                    r = r + key + pKey.replace(/[": ]/g, '') + '</span>: ';
                if (pVal)
                    r = r + (pVal[0] == '"' ? str : val) + pVal + '</span>';
                return r + (pEnd || '');
            },
            prettyPrint: function(obj) {
                var jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/mg;
                return JSON.stringify(obj, null, 3)
                    .replace(/&/g, '&amp;').replace(/\\"/g, '&quot;')
                    .replace(/</g, '&lt;').replace(/>/g, '&gt;')
                    .replace(jsonLine, library.json.replacer);
            }
        };


        $('code.json').each(function () {
            var tmpData = JSON.parse($(this).text());
            $(this).html(library.json.prettyPrint(tmpData));
        });
    });
</script>
<style>
    pre {
        background-color: #f8f8ff;
        border: 1px solid #C0C0C0;
        padding: 10px 20px;
        margin: 20px;
    }
    .json-key {
        color: #A52A2A;
    }
    .json-value {
        color: #000080;
    }
    .json-string {
        color: #556b2f;
    }
</style>
{/literal}