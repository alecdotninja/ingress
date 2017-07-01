class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices, id: :uuid do |t|
      t.macaddr :mac_addr, index: { unique: true }, null: false
      t.inet :current_ip_addr

      t.string :name
      t.attachment :theme_song

      t.timestamps
    end
  end
end
