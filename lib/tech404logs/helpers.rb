module Tech404logs
  module Helpers
    def channel_path(channel_or_name, date = nil)
      name = channel_name(channel_or_name)
      if date
        "/#{name}/#{date.strftime('%Y-%m-%d')}"
      else
        "/#{name}"
      end
    end

    def channel_sitemap_path(channel_or_name)
      "/#{channel_name(channel_or_name)}/sitemap.xml"
    end

    def date
      if params[:date]
        Time.zone.parse(params[:date][0..10])
      else
        Time.zone.now
      end
    end

    def channels
      Channel.indexing
    end

    def format_message(text)
      text = UserMentionFilter.apply(text)
      text = ChannelMentionFilter.apply(text)
      text = MessageFormatFilter.apply(text)
      text = LinkFormatFilter.apply(text)
      text
    end

    def format_time(time, format: '%-H:%M')
      time.in_time_zone.strftime(format)
    end

    def message_dom_id(message)
      "message-#{message.id}"
    end

    def message_path(message)
      channel = channel_path(message.channel, message.timestamp)
      "#{channel}##{message_dom_id(message)}"
    end

    def title
      [].tap do |parts|
        parts << @channel.name if @channel
        parts << params[:q] if params[:q]
        parts << 'Tech404logs'
        parts << "Archived transcripts from Atlanta's Tech404 community Slack"
      end.join(' | ')
    end

    def search_path(query, page: 1)
      if page > 1
        "/search?q=#{query}&page=#{page}"
      else
        "/search?q=#{query}"
      end
    end

    ###
    # Converts a channel name or channel object into a channel name
    #
    def channel_name(channel_or_name)
      case channel_or_name
      when Channel
        channel_or_name.name
      when String
        channel_or_name
      end
    end
  end
end
