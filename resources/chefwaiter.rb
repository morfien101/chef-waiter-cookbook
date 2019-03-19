resource_name :chefwaiter
property :minutes_from_now, Integer, default: 5

action :schedule_restart do
  if os? 'windows'
    # For windows we just need to set a task
    windows_task 'restart_chefwaiter' do
      action :create
      run_level :highest
      frequency :once
      start_time((Time.now + (new_resource.minutes_from_now * 60)).strftime('%H:%M'))
      command %(chef-client -o 'recipe[chef-waiter::restart_chefwaiter]')
      only_if { ::Chefwaiter.service_installed? }
    end
  else
    # For linux we install at and use that to schedule a time
    install_at

    # tell at what to do.
    execute 'restart_chefwaiter' do
      command %(echo "#{which_chefclient} -o 'recipe[chef-waiter::restart_chefwaiter]'" | #{which_at} now + #{new_resource.minutes_from_now} minutes )
      action :run
      only_if { ::Chefwaiter.service_installed? }
    end
  end
end

action :remove_scheduled_restart do
  windows_task 'restart_chefwaiter' do
    action :delete
  end if os? 'windows'
end

action :schedule_upgrade do
  # We need to trigger an upgrade process
  if os?('windows')
    # Windows needs a schedualed task
    windows_task 'upgrade_chefwaiter' do
      action [:delete, :create]
      run_level :highest
      frequency :once
      start_time((Time.now + (5 * 60)).strftime('%H:%M'))
      command %(chef-client -o 'recipe[chef-waiter::upgrade_chefwaiter]')
      only_if { ::Chefwaiter.update_required? }
    end
  else
    # Linux needs AT to be installed.
    install_at
    execute 'upgrade chefwaiter' do
      command %(echo "#{which_chefclient} -o 'recipe[chef-waiter::upgrade_chefwaiter]'" | #{which_at} now + #{new_resource.minutes_from_now} minutes )
      action :run
      only_if { ::Chefwaiter.update_required? }
    end
  end
end

action :remove_scheduled_upgrade do
  # We can delete the task to upgrade because we have finished an upgrade.
  # Else if something fails it will start again.
  windows_task 'upgrade_chefwaiter' do
    action :delete
  end if os? 'windows'
end

action :schedule_uninstall do
  # We need to trigger an upgrade process
  if os?('windows')
    # Windows needs a schedualed task
    windows_task 'remove_chefwaiter' do
      action [:delete, :create]
      run_level :highest
      frequency :once
      start_time((Time.now + (5 * 60)).strftime('%H:%M'))
      command %(chef-client -o 'recipe[chef-waiter::remove_chef_waiter]')
      only_if { ::Chefwaiter.update_required? }
    end
  else
    # Linux needs AT to be installed.
    install_at
    execute 'remove chefwaiter' do
      command %(echo "#{which_chefclient} -o 'recipe[chef-waiter::remove_chef_waiter]'" | #{which_at} now + #{new_resource.minutes_from_now} minutes )
      action :run
      only_if { ::Chefwaiter.update_required? }
    end
  end
end

action_class do
  def install_at
    package 'at'
    service 'atd' do
      action [:enable, :start]
    end
  end
end
