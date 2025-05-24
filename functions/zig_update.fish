function zig_update
    set -f zig_version_install "$argv[1]"
    set -f current_zig_version (zig version)

    if test -z "$zig_version_install"
        set -f zig_version_install master
    end

    echo "Zig install version is set to: $zig_version_install"

    set -l remote_json (curl https://ziglang.org/download/index.json)

    if test "$zig_version_install" = master
        if test "$current_zig_version" = (echo $remote_json | jq -r '.master.version')
            echo "Already installed"
            return
        end
    end

    if test -z "$(echo $remote_json | jq -r ".\"$zig_version_install\"")"
        echo "Version $zig_version_install not found"
        return
    end

    mkdir /tmp/zig_update

    switch (uname)
        case Linux
            set -f query ".\"$zig_version_install\".\"x86_64-linux\".tarball"
        case Darwin
            set -f query ".\"$zig_version_install\".\"aarch64-macos\".tarball"
        case '*'
            echo "Unsupported OS"
            return
    end

    echo "Downloading metadata..."
    set -l tar_url (echo $remote_json | jq -r $query)

    echo "Downloading tarball..."
    curl -o /tmp/zig_update/zig.tar.xz $tar_url

    echo "Unpacking tarball..."
    mkdir /tmp/zig_update/unpacked
    tar --strip-components=1 -xf /tmp/zig_update/zig.tar.xz -C /tmp/zig_update/unpacked

    echo "Installing... requires root elevation"
    sudo rm /usr/local/bin/zig 2>/dev/null
    sudo rm -r /usr/local/zig/* 2>/dev/null
    sudo mv /tmp/zig_update/unpacked/* /usr/local/zig
    sudo ln -s /usr/local/zig/zig /usr/local/bin/zig

    echo "Cleaning up..."
    rm -rf /tmp/zig_update
end
