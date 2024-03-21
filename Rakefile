task :spec do
  Dir['spec/*_spec.rb'].each do |path|
    load(path)
  end
end

task :watch do
  files = Dir['**/*.rb', 'src/*.c']
  sh %(ls #{files.join(' ')} | entr -c -s 'rake spec')
end
