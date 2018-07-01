(
  defined?(::UserSerializer) ? (::UserSerializer) : (UserSerializer = Class.new(ActiveModel::Serializer) { attributes :id })
 ).class_eval do
  attributes :is_templates_moderator
end
