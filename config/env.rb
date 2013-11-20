# Load default env vars if not already set.

unless Rails.env.production?
  StarterKit::Settings.env.each do |k, v|
    ENV[k] ||= v
  end
end
