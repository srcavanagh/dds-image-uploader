module MegaHelper

    def names_array 
        names = []
        Net::SFTP.start("#{ENV['SFTP_HO']}", "#{ENV['SFTP_US']}", :password => "#{ENV['SFTP_PA']}", :port => 2222) do |sftp|
            sftp.dir.foreach("/imagenes") do |entry|
                names << entry.name
            end
        end
        names.sort!
        return names
    end

    def aws_obj image
        ak = ENV['AWS_AK']
        sk = ENV['AWS_SK']
        Aws.config.update({
            region: 'us-east-1',
            credentials: Aws::Credentials.new(ak, sk),
        })

        s3 = Aws::S3::Resource.new(region:'us-east-1')
        @bucket = s3.bucket('fj-aws-s3-uploads')
        obj = @bucket.object("dds/#{image}")
        return obj
    end

    def download_to_tmp image        
        Net::SFTP.start("#{ENV['SFTP_HO']}", "#{ENV['SFTP_US']}", :password => "#{ENV['SFTP_PA']}", :port => 2222) do |sftp|
            sftp.download!("/imagenes/#{image}", "tmp/#{image}")
        end
    end

end