require "shellwords"

def cb_invite(data, signal, signal_data)
    details = Weechat.info_get_hashtable(
        "irc_message_parse",
        {"message" => signal_data}
    )

    simple_notify(
        "Channel Invitation",
        "#{details["nick"]} has invited you to #{details["text"]}"
    )

    return Weechat::WEECHAT_RC_OK
end

def cb_privmsg(data, signal, signal_data)
    details = Weechat.info_get_hashtable(
        "irc_message_parse",
        {"message" => signal_data}
    )

    if (details["text"].match(/ACTION.*$/))
        text = details["text"].gsub(/ACTION (.+)/, "\\1")

        if (details["channel"] == details["nick"])
            simple_notify("Private Action: #{details["nick"]}", text)
        else
            simple_notify(
                "Action: #{details["channel"]}",
                "#{details["nick"]} | #{text}"
            )
        end
    else
        if (details["channel"] == details["nick"])
            simple_notify(
                "Private: #{details["nick"]}",
                details["text"]
            )
        else
            simple_notify(
                details["channel"],
                "#{details["nick"]} | #{details["text"]}"
            )
        end
    end

    return Weechat::WEECHAT_RC_OK
end

def cb_topic(data, signal, signal_data)
    details = Weechat.info_get_hashtable(
        "irc_message_parse",
        {"message" => signal_data}
    )

    simple_notify(
        "Channel Topic",
        "#{details["channel"]}: #{details["text"]}"
    )

    return Weechat::WEECHAT_RC_OK
end

def simple_notify(title, message)
    t = title.gsub("\\", "\\\\\\").shellescape
    m = message.gsub("\\", "\\\\\\").shellescape

    if (RUBY_PLATFORM.match(/darwin/))
        system("terminal-notifier -title #{t} -message #{m}")
    else
        system("notify-send -t 3000 -- #{t} #{m}")
    end
end

def weechat_init
    Weechat.register(
        "simple_notify",
        "Miles Whittaker <mjwhitta@gmail.com>",
        "1.1",
        "GPLv3",
        "Sends libnotify notifications upon events",
        "",
        ""
    )

    settings = {
        "icon" => "~/.weechat/weechat_logo_64x64.png",
        "show_channel_topic" => "on",
        "show_invite_message" => "on",
        "show_private_action_message" => "on",
        "show_private_message" => "on",
        "show_public_action_message" => "off",
        "show_public_message" => "on"
    }

    settings.each do |k, v|
        if (!Weechat.config_is_set_plugin(k))
            # Why doesn't this work?!
            Weechat.config_set_plugin(k, v)
        end
    end

    Weechat.hook_signal("*,irc_in2_invite", "cb_invite", "")
    Weechat.hook_signal("*,irc_in2_privmsg", "cb_privmsg", "")
    Weechat.hook_signal("*,irc_in2_topic", "cb_topic", "")

    return Weechat::WEECHAT_RC_OK
end
