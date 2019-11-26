def afk_cb(data, buffer, args)
    cmd = "/away -all"
    cmd += " #{args}" if (args && !args.empty?)
    Weechat.command("", cmd)

    # Get nick
    nick = nil
    infolist = Weechat.infolist_get("irc_server", "", "")
    while (Weechat.infolist_next(infolist) > 0)
        nick = Weechat.infolist_string(infolist, "nick")
        nick = nil if (nick.empty?)
        break if (nick)
    end
    Weechat.infolist_free(infolist)

    if (nick)
        cmd = "/nick -all #{nick.gsub(/_afk$/, "")}"
        cmd += "_afk" if (args && !args.empty?)
        Weechat.command("", cmd)
    end

    return 1
end

def weechat_init
    Weechat.register(
        "afk",
        "Miles Whittaker <mjwhitta@gmail.com>",
        "1.1",
        "GPLv3",
        "Set or clear afk status",
        "",
        ""
    )

    settings = Hash.new

    settings.each do |k, v|
        if (!Weechat.config_is_set_plugin(k))
            Weechat.config_set_plugin(k, v)
        end
    end

    Weechat.hook_command(
        "afk",
        "Set or clear afk status",
        "[status]",
        "status: Status message",
        "",
        "afk_cb",
        ""
    )

    return Weechat::WEECHAT_RC_OK
end
