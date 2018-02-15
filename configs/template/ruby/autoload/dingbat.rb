def ding(nick, cmd, rc, out, err)
    Weechat.command("", "/msg #{nick} #{nick}: ding")
end

def ding_cb(data, buffer, args)
    input = args.split(/ +/)
    if (input.length < 2)
        Weechat.command("", "/help ding")
        return 0
    end

    n = input.delete_at(0).to_i
    if (n == 0)
        Weechat.command("", "/help ding")
        return 0
    end

    n.times do |i|
        input.each do |nick|
            Weechat.hook_process("sleep #{i}", n * 1000, "ding", nick)
        end
    end

    return 1
end

def weechat_init
    Weechat.register(
        "dingbat",
        "Miles Whittaker <mjwhitta@gmail.com>",
        "1.0",
        "GPLv3",
        "Ding someone a lot",
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
        "ding",
        "Ding someone(s) a lot",
        "<num> <nick>...[nick]",
        [
            "nick: Nickname for user to ding",
            "num: Number of times to ding",
        ].join("\n"),
        "",
        "ding_cb",
        ""
    )

    return Weechat::WEECHAT_RC_OK
end
