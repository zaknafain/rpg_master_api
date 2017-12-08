class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at, :admin, :locale
  
end
