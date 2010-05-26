# Custom pagination for taggable objects, modified to work with latest versions by Shawn Hamill
#   Latest versions of acts_as_taggable_on_steroids and will_paginate
module ActiveRecord
    module Acts #:nodoc:
        module Taggable #:nodoc:
            module SingletonMethods

                def count_tagged_with(*args)
                    options = find_options_for_find_tagged_with(*args)
                    options.blank? ? 0 : count("#{table_name}.id", options.merge(:select => nil, :distinct => true))
                end

                def paginate_tagged_with(tags, options = {})
                    page, per_page, total_entries = wp_parse_options(options)
                    offset = (page.to_i - 1) * per_page
                    options.except! :page, :per_page, :total_entries, :finder

                    returning WillPaginate::Collection.new(page, per_page, total_entries) do |p|
                        p.replace find_tagged_with(tags, options.merge(:offset => offset, :limit => per_page.to_i))
                        p.total_entries = count_tagged_with(tags, (options.except :order)) unless p.total_entries                        
                    end
                end
            end
        end
    end
end