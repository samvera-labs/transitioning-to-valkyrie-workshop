Hyrax::Transactions::Container.register('work_resource.mint_id', MintId.new)

class ApplicationContainerOverrides
  extend Dry::Container::Mixin

  namespace 'change_set' do |ops|
    ops.register 'create_work' do
      Hyrax::Transactions::WorkCreate.new(steps:
        ['change_set.set_default_admin_set',
         'change_set.ensure_admin_set',
         'change_set.set_user_as_depositor',
         'change_set.apply',
         'work_resource.mint_id',
         'work_resource.apply_permission_template',
         'work_resource.save_acl',
         'work_resource.add_file_sets',
         'work_resource.change_depositor',
         'work_resource.add_to_parent'])
    end
  end
end

Hyrax::Transactions::Container.merge(ApplicationContainerOverrides)
