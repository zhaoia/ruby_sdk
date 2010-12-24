#encoding: utf-8
require 'net/http'
require 'uri'
require 'digest'

class Zhaoia
   def initialize(options)
      @zhaoia_root = options[:url]
      @app_key = options[:app_key]
      @secret_code = options[:secret_code]
   end

   def get_sign(params)
      src = params.sort.collect{|k,v|"#{k}=#{v}"}.join('&')+"&secretcode=#{@secret_code}"
      Digest::MD5.hexdigest(src).upcase 
   end

   def get_results(name,params)
      url = "#{@zhaoia_root}/#{name}"
      params['sign'] = get_sign(params)
      res = Net::HTTP.post_form(URI.parse(url),params)
      res.body
   end

   def get_product_lists(keyword,page=1,per_page=16,sort='')
      params = {
         'appkey'=>@app_key,
         'keyword'=>keyword,
         'page'=>page,
         'per_page'=>per_page,
         'sort'=>sort
      }
      get_results("get_product_lists",params)
   end

   def get_product_info(id)
      params = {
         'appkey'=>@app_key,
         'id'=>id
      }
      get_results('get_product_info',params)
   end

   def get_related_product_lists(id,lsize=8)
      params = {
         'appkey'=>@app_key,
         'id'=>id,
         'lsize'=>lsize
      }
      get_results('get_related_product_lists',params)
   end

   def get_context_product_lists(keyword,lurl,lsize=8)
      params = {
         'appkey'=>@app_key,
         'keyword'=>keyword,
         'url'=>lurl,
         'lsize'=>lsize
      }
      get_results('get_context_product_lists',params)
   end
end

if __FILE__ == $0
   url=ARGV.first || 'http://www.zhaoia.com/service'
   z = Zhaoia.new(:url=>url,:app_key=>'29286397',:secret_code=>'78cf14f220bdffa07e')
   puts z.get_product_lists('索尼')
   puts z.get_product_info('85f286c812340d61c727a427bd527566')
   puts z.get_related_product_lists('85f286c812340d61c727a427bd527566',lsize=6)
   puts z.get_context_product_lists('Canon 佳能 EOS 500D 单反相机 套机 含18-55IS头 - 新蛋中国','http://www.newegg.com.cn/Product/90-c13-193.htm')
end
# vim:ts=3:sw=3:
