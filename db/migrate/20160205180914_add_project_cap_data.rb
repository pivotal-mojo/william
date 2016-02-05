class AddProjectCapData < ActiveRecord::Migration
  def up
    execute <<-SQL
    UPDATE projects SET cpu_cap=15, memory_cap=100000, storage_cap=5000, linux_os_cap=5, windows_os_cap=2 WHERE name='Aardvark';
    UPDATE projects SET cpu_cap=12, memory_cap=80000, storage_cap=900, linux_os_cap=3, windows_os_cap=3 WHERE name='Antelope';
    UPDATE projects SET cpu_cap=8, memory_cap=10000, storage_cap=3500, linux_os_cap=1, windows_os_cap=4 WHERE name='Goat';
    UPDATE projects SET cpu_cap=1, memory_cap=4096, storage_cap=100, linux_os_cap=0, windows_os_cap=1 WHERE name='Giraffe';
    SQL
  end
end
