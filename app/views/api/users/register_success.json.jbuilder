json.status 200
json.user do
  json.partial! 'show', user: @user
end