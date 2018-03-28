from __future__ import absolute_import

from sphinx.application import TemplateBridge
from mako.lookup import TemplateLookup
import os

class MakoBridge(TemplateBridge):
    def init(self, builder, *args, **kw):
        self.layout = builder.config.html_context.get('mako_layout', 'html')

        self.lookup = TemplateLookup(directories=builder.config.templates_path,
            format_exceptions=True,
            imports=[
                "from _builder import util"
            ]
        )

    def render(self, template, context):
        template = template.replace(".html", ".mako")
        context['prevtopic'] = context.pop('prev', None)
        context['nexttopic'] = context.pop('next', None)
        context['mako_layout'] = self.layout == 'html' and 'static_base.mako' or 'site_base.mako'
        # sphinx 1.0b2 doesn't seem to be providing _ for some reason...
        context.setdefault('_', lambda x:x)
        return self.lookup.get_template(template).render_unicode(**context)

    def render_string(self, template, context):
        context['prevtopic'] = context.pop('prev', None)
        context['nexttopic'] = context.pop('next', None)
        context['mako_layout'] = self.layout == 'html' and 'static_base.mako' or 'site_base.mako'
        # sphinx 1.0b2 doesn't seem to be providing _ for some reason...
        context.setdefault('_', lambda x:x)
        return Template(template, lookup=self.lookup,
            format_exceptions=True,
            imports=[
                "from _builder import util"
            ]
        ).render_unicode(**context)
