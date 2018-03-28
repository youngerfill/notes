<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%!
    import conf

    def us(s):
        return s.replace(" ","_")

    def trimTrailingHash(s):
        lastCharIdx = len(s)-1
        if s[lastCharIdx]=='#':
            return s[:lastCharIdx-1]
        else:
            return s
%>
<head>
    % if pagename != master_doc:
    <title>${title}</title>
    % else:
    <title>${conf.sitename}</title>
    % endif
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="${pathto('_static/style.css', 1)}" type="text/css" />
% if pagename != master_doc:
    <link rel="stylesheet" href="${pathto('_static/pygments.css', 1)}" type="text/css" />
% endif
</head>
<body>
## Normal layout, for everything but the frontpage
% if pagename != master_doc:
    <div id="header">
        <div class="nav">
            <div class="path">
                <a href="${pathto(master_doc)}">${conf.sitename}</a> &#47;
        % for parent in parents:
                <a href="${parent['link']|h}">${parent['title']}</a> &#47;
        % endfor
        ## Trim trailing hash character, if any
                <a href="${pathto(pagename)|trimTrailingHash}"> ${title} </a>
            </div>
<%
    if 'browse_root' in meta:
        browse_root = meta['browse_root']
        browse_root_page = browse_root + "/index"

        import os, string

        current_page_folder = os.path.split(pagename)[0]

        if prevtopic:
            prevtopic_name=os.path.normpath(os.path.join(current_page_folder,os.path.split(prevtopic['link'])[0]))
            has_prev = 1 if prevtopic_name.find(browse_root) == 0 else None
            rel_path_to_browse_root = os.path.relpath(browse_root,current_page_folder) + "/index.html"
            browse_root_title = ""
            for parent in parents:
                if parent['link'] == rel_path_to_browse_root:
                    browse_root_title = parent['title']
                    break

        if nexttopic:
            nexttopic_name=os.path.normpath(os.path.join(current_page_folder,os.path.split(nexttopic['link'])[0]))
            has_next = 1 if nexttopic_name.find(browse_root) == 0 else None

    else:
        browse_root = None
%>
    <%block name="browse">
        % if browse_root:
            <div class="browse">
                % if prevtopic:
                    % if has_prev:
                        <a href="${prevtopic['link']}" title="${prevtopic['title']}">&lt;previous</a> | <a href="${pathto(browse_root_page)}" title="${browse_root_title}">TOC</a>
                    % else:
                        <span class="invisible">&lt;previous | TOC </span>
                    % endif
                % endif

                % if nexttopic:
                    % if has_next:
                        % if prevtopic:
                            % if has_prev:
                                |
                            % endif
                        % endif
                        <a href="${nexttopic['link']}" title="${nexttopic['title']}">next&gt;</a>
                    % else:
                        <span class="invisible">
                        % if prevtopic:
                            % if has_prev:
                                |
                            % endif
                        % endif
                        next&gt;</span>
                    % endif
                % endif
            </div>
        % endif
    </%block>
    ${browse()}
        </div>
    % if 'notimestamp' not in meta:
        <%
            from os import getcwd
            from os.path import getmtime
            from time import strftime, gmtime
#            modTime  = strftime('%Y-%m-%d %H:%M:%S', gmtime(getmtime(getcwd() + '/source/' + sourcename[:len(sourcename)-3] + 'rst')))
            modTime  = strftime('%Y-%m-%d %H:%M:%S', gmtime(getmtime(getcwd() + '/source/' + sourcename[:len(sourcename)-4])))
        %>
            <div class="timestamp" title="Last modified">
                ${modTime} UTC
            </div>
    % endif
    <%
        if 'tags' in meta:
            tagsList = meta['tags'].split('|')
            import os
            base_path = os.path.dirname(pathto(master_doc))
        else:
            tagsList = []
    %>
    % if tagsList:
        <div class="tags">
        % for i, tag in enumerate(tagsList):
            % if i!=0:
                |
            % endif
            <a href="${base_path}/tags/${tag|us,u}/index.html" title="tag"> ${tag} </a>
        % endfor
        </div>
    % endif

    </div>

    <div id="document">
        ${body}
    </div>
    <div id="footer">
    ${browse()}
## Frontpage layout
% else:
    <div id="headerfp">
        <div class="navbig">
            <a href="${pathto(master_doc)|trimTrailingHash}">${conf.sitename}</a>
        </div>
          <div class="slogan">
            ${conf.slogan}
          </div>

    </div>

    <div id="documentfp">
##        <div class="fpintro">On this site I collect my various projects, scripts and code snippets.</div>
        <%include file="top.mako"/>
        <div class="frontpagepanel">
            <div class="fpmenu">
                <div class="menuitem">
                    <div class="raquo">&raquo;</div>
                    <a class="menulink" href="about/index.html">About</a>
                </div>
                <div class="menuitem">
                    <div class="raquo">&raquo;</div>
                    <a class="menulink" href="pageindex/index.html">Page index</a>
                </div>
                <div class="menuitem">
                    <div class="raquo">&raquo;</div>
                    <a class="menulink" href="tags/index.html">Tags</a>
                </div>
                <div class="menuitem">
                    <div class="raquo">&raquo;</div>
                    <a class="menulink" href="sitemap/index.html">Sitemap</a>
                </div>
            </div>
            <div class="latestchanges">
                <div class="lctitle"> Latest updates:</div>
                ${body}
            </div>
        </div>
##        <p>
##                Jump right to:
##        <p>
##                    babs    clapi   inima   anthos    cheat sheet
##        <p>
##                <a href="https://github.com/bergoid">Source repos on Github</a>
<%include file="bottom.mako"/>
    </div>
    <div id="footerfp">
% endif
        <%include file="footer.mako"/>
##        <div class="bottomlinks">License | <a href="mailto:bert@libera.be">Contact</a></div>
    </div>
</body>
</html>
