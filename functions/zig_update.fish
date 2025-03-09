function zig_update
    set -l remote_json (curl https://ziglang.org/download/index.json)

    if test (zig version) = (echo $remote_json | jq -r '.master.version')
        echo "Already up to date"
        return
    end

    mkdir /tmp/zig_update

    echo "Downloading metadata..."
    set -l tar_url (echo $remote_json | jq -r '.master."aarch64-macos".tarball')

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
