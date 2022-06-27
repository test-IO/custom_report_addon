# Custom Report
This is an example of an addon for the platform TEST IO.
Addons need for expanding functionality.
Concerning an addon and the platform, you need a prepared API that will get data from the addon.

# Installation an addon to the platform:
* Instalation endpoint on addon side (example: config/routes.rb:2)
* Descriptor endpoint on addon side (example: config/routes.rb:4)
* Descriptor schema ()
The example of a descriptor you can find here:
```sh
Addon: app/controllers/addons_controller.rb:20
```

As can you descriptor contains data for the addon on the platform side.
```sh
{
      key: @addon.key, # Uniq name of addon
      title: @addon.title, # Public title of addon that can see user
      base_url: Settings.host, # Domain of addon
      installation_webhook_path: addon_install_path(@addon.key), # Path for installation
      uninstallation_webhook_path: addon_uninstall_path(@addon.key), # path for unstallation
      new_report_path: new_report_path(@addon.key) # Path for create a new report(the main functional of report)
    }
```
Example of url to descriptor:
```sh
http://localhost:4005/addons/dog/descriptor.json
```

Where 'dog' is a key of the addon. By key, we are finding some addons on the addon side and getting information for the descriptor. After calling the descriptor URL from the platform we are getting information from the descriptor to the addon on the platform side.

# Uninstallation an addon from the platform:
* Instalation endpoint on addon side(example: config/routes.rb:4)

# Flow for setting an addon

### On the Addon side
```sh
Addon.create(key: 'bird', description: 'test', title: 'Bird Addon')
```

```sh
 id: 3,                                                     
 key: "bird",                                               
 title: "Bird Addon",                                       
 description: "test",                                       
 status: "pending",                                         
 client_key: nil,  # will be getting from platform                                         
 shared_secret_key: nil, # will be getting from platform                                  
 created_at: Mon, 27 Jun 2022 06:11:22.421988000 UTC +00:00,
 updated_at: Mon, 27 Jun 2022 06:11:22.421988000 UTC +00:00>
```

### On the platform side
<img width="552" alt="Screenshot 2022-06-27 at 10 16 49" src="https://user-images.githubusercontent.com/20345554/175877901-608050ad-a6ef-4423-870c-c8d32313ee98.png">

An addon has been created after updating of product and has the following data:
```sh
 id: 4,
 title: nil, # will be got from descriptor
 description: nil,
 key: nil, # will be got from descriptor
 status: "pending",
 base_url: nil, # will be got from descriptor
 installation_webhook_path: nil, # will be got from descriptor
 uninstallation_webhook_path: nil, # will be got from descriptor
 new_report_path: nil, # will be got from descriptor
 client_key: "ee423ad946ae8186", # will be send to addon side
 shared_secret_key: "9e5c395c42740d7dea48c92e295bf775", # will be send to addon side
 descriptor_url: "http://localhost:4005/addons/bird/descriptor.json",
 created_at: Mon, 27 Jun 2022 08:22:14.313235000 CEST +02:00,
 updated_at: Mon, 27 Jun 2022 08:22:14.313235000 CEST +02:00>
```
After saving the addon if the descriptor URL has been changed we call descriptor for setting data of this addon.
```sh
TEST IO: app/models/addon.rb:72
```
Addon after setting data from descriptor:
```sh
 id: 5,
 title: "Bird Addon",
 description: nil,
 key: "bird",
 status: "installed",
 base_url: "http://localhost:4005",
 installation_webhook_path: "/addons/bird/install",
 uninstallation_webhook_path: "/addons/bird/uninstall",
 new_report_path: "/addons/bird/new_report",
 client_key: "95e9ab04262d66a2",
 shared_secret_key: "1bc4b28bc694cfb49c6df52938361ae8",
 descriptor_url: "http://localhost:4005/addons/bird/descriptor.json",
 created_at: Mon, 27 Jun 2022 08:30:57.229618000 CEST +02:00,
 updated_at: Mon, 27 Jun 2022 08:30:58.086640000 CEST +02:00>
```

The final step. After setting 'installation_webhook_path' to addon we can relate addon on platform and addon on the Addon side. We call Addons::Webhook installation.
```sh
TEST IO: app/models/addon.rb:76 # Send keys
Addon: app/controllers/addons_controller.rb::6 # Get keys
```
As a result we send 'client_key' and 'shared_secret_key' to Addon side
```sh
 id: 3,
 key: "bird",
 title: "Bird Addon",
 description: "test",
 status: "installed",
 client_key: "[FILTERED]",
 shared_secret_key: "[FILTERED]",
 created_at: Mon, 27 Jun 2022 06:11:22.421988000 UTC +00:00,
 updated_at: Mon, 27 Jun 2022 06:37:50.466494000 UTC +00:00>
```
Well done! Addon has been set to the platform. 
### Important!

client_key and shared_secret_key are needed for the safety work of API.
An example of API on the platform side you can find here:
```sh
app/api/custom_report
```

