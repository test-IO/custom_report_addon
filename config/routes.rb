Rails.application.routes.draw do
    post 'addons/:id/install', to: 'addons#install', as: :addon_install
    post 'addons/:id/uninstall', to: 'addons#uninstall', as: :addon_uninstall
    get 'addons/:id/descriptor', to: 'addons#descriptor', as: :addon_descriptor

    get 'addons/:id/new_report', to: 'reports#new', as: :new_report
    post 'addons/:id/create_report', to: 'reports#create', as: :create_report
    post 'addons/:id/create_attachment', to: 'reports#create_attachment', as: :create_attachment
end
