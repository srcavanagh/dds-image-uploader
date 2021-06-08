# ~$ => rake integrator:discover 
# -> Ir a la app de heroku
# -> Agregar heroku scheduler
# -> Cronear para que cada 10min corra el rake integrator:process

namespace :integrator do # rake integrator:
    # ... tasks
    task :process => :environment do # rake integrator:process
        include Megahelper

        # TODO: Leer posicion actual desde la BD
        contador = ContadorState.all.first
        position = contador.position

        if position > 0
            names = names_array()
            names[position..-1].each do |image|
                download_to_tmp image
                obj = aws_obj image
                if !obj.exists?
                    filePath = "#{Rails.root}/tmp/#{image}"
                    obj.upload_file(filePath, {acl: 'public-read'})
                end
                remote_url = obj.public_url
                puts remote_url
    
                contador.position += 1
                contador.save
            end 
    
            contador.position = -1
            contador.save
        end
    end
end