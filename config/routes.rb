Rails.application.routes.draw do
 
  root 'home#index'

  get  'ruby' => 'ruby#index'
  post 'ruby_eval' => 'ruby#ruby_eval'

end
