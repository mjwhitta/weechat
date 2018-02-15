def deop(mode, cmd, rc, out, err)
    Weechat.command("", "/mode #{mode}")
end

def join_cb(data, signal, signal_data)
    # Get my nick
    mynick = nil
    infolist = Weechat.infolist_get("irc_server", "", "")
    while (Weechat.infolist_next(infolist) > 0)
        mynick = Weechat.infolist_string(infolist, "nick")
        mynick = nil if (mynick.empty?)
        break if (mynick)
    end
    Weechat.infolist_free(infolist)

    if (mynick)
        nick = Weechat.info_get("irc_nick_from_host", signal_data)
        channel = signal_data.split(":")[-1]
        if (mynick == nick)
            Weechat.hook_process(
                "sleep 1",
                1000,
                "deop",
                "#{channel} -o #{mynick}"
            )
        end
    end

    return 1
end

def weechat_init
    Weechat.register(
        "auto_deop_on_join",
        "Miles Whittaker <mjwhitta@gmail.com>",
        "1.0",
        "GPLv3",
        "Automatically deop yourself when joining a new channel",
        "",
        ""
    )

    settings = Hash.new

    settings.each do |k, v|
        if (!Weechat.config_is_set_plugin(k))
            Weechat.config_set_plugin(k, v)
        end
    end

    Weechat.hook_signal("*,irc_in2_join", "join_cb", "")

    return Weechat::WEECHAT_RC_OK
end
