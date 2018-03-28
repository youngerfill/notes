from sphinx.application import TemplateBridge
from sphinx.builders.html import StandaloneHTMLBuilder
from mako.lookup import TemplateLookup
from mako.template import Template
from mako.ext.pygmentplugin import MakoLexer

class MakoBridge(TemplateBridge):
    def init(self, builder, *args, **kw):
         builder.config.html_context['site_base'] = builder.config['site_base']

         self.lookup = TemplateLookup(
            directories=builder.config.templates_path,
            imports=[
                "from _builder import util"
            ]
        )

    def render(self, template, context):
        template = template.replace(".html", ".mako")
        context['prevtopic'] = context.pop('prev', None)
        context['nexttopic'] = context.pop('next', None)
        context['layout'] = "layout.mako"

        context.setdefault('_', lambda x:x)
        return self.lookup.get_template(template).render_unicode(**context)

    def render_string(self, template, context):
        context['prevtopic'] = context.pop('prev', None)
        context['nexttopic'] = context.pop('next', None)
        context.setdefault('_', lambda x:x)
        return Template(template, lookup=self.lookup,
            format_exceptions=True,
            imports=[
                "from _builder import util"
            ]
        ).render_unicode(**context)

def setup(app):
    app.add_lexer('mako', MakoLexer())
    app.add_config_value('site_base', "", True)
