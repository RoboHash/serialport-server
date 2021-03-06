module SerialportServer
  class SocketServer < EM::Connection
    def post_init
      @sid = SerialportServer.application.channel.subscribe do |data|
        send_data "#{data}\n"
      end
      puts "* new socket client <#{@sid}>"

      def receive_data data
        data = data.to_s.strip
        return if data.size < 1
        puts "* socket client <#{@sid}> : #{data}"
        SerialportServer.application.serialport.puts data
      end

      def unbind
        SerialportServer.application.channel.unsubscribe @sid
        puts "* socket client <#{@sid}> closed"
      end
    end
  end
end
