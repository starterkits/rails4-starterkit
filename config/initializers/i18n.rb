# Include metadata to determine which validation caused the error: :taken, :blank, :too_long, etc.
# Example:
#   resource.errors.first[1].translation_metadata
#   resource.errors[:name].first.translation_metadata
#   => {:original=>"Name has already been taken", :locale=>:en, :key=>:"activerecord.errors.models.tag.attributes.name.taken", :scope=>nil, :default=>[:"activerecord.errors.models.tag.taken", :"activerecord.errors.messages.taken", :"errors.attributes.name.taken", :"errors.messages.taken"], :separator=>nil, :values=>{:model=>"Tag", :attribute=>"Name", :value=>"unde1"
I18n.backend.class.send(:include, I18n::Backend::Metadata)

# Cache I18n lookups
I18n::backend.class.send(:include, I18n::Backend::Cache)
I18n.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)
# I18n.cache_store = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
