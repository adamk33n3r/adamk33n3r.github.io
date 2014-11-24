module Code
    class CodeGen < Jekyll::Tags::HighlightBlock
        # LAME GITHUB PAGES DOESNT LET YOU DO CUSTOM PLUGINS!!!
        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
            formatted_code = super
            before_select = "<div class=\"code-box default\">" +
                "<div class=\"code-box-header\">" +
                    @lang +
                    "<select>"
            files = Dir.chdir("./css/pygments/"){Dir["*.css"]}
            options = ""
            for style in files.collect{|file| file[0..-5]} do
                options += "<option value=\"#{style}\">#{style.capitalize}</option>"
            end
            after_select =
                    "</select>" +
                "</div>" +
                formatted_code +
            "</div>"
            before_select + options + after_select
        end
    end
end


Liquid::Template.register_tag('code', Code::CodeGen)
