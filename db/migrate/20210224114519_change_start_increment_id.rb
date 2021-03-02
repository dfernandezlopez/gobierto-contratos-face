# if our database is already populated with data
class ChangeStartIncrementId < ActiveRecord::Migration[6.1]
  def up
    execute(%q{
      select setval('fiscal_entities_id_seq', (select max(id) from fiscal_entities))
    })
  end
end
