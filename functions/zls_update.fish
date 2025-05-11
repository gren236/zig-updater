function zls_update
    set -l zls_version (/usr/local/bin/zls --version)
    set -l remote_json (curl --get \
        --data-urlencode "zig_version=$(zig version)" \
        --data-urlencode "compatibility=only-runtime" \
        "https://releases.zigtools.org/v1/zls/select-version")

    if test "$zls_version" = (echo $remote_json | jq -r '.version')
        echo "Already up to date"
        return
    end

    mkdir /tmp/zls_update

    switch (uname)
        case Linux
            set -f query '."x86_64-linux".tarball'
        case Darwin
            set -f query '."aarch64-macos".tarball'
        case '*'
            echo "Unsupported OS"
            return
    end

    echo "Downloading tarball for version $zls_version..."
    curl -L -o /tmp/zls_update/zls.tar.xz (echo $remote_json | jq -r $query)

    echo "Unpacking tarball..."
    mkdir /tmp/zls_update/unpacked
    tar -xf /tmp/zls_update/zls.tar.xz -C /tmp/zls_update/unpacked

    echo "Installing... requires root elevation"
    sudo rm /usr/local/bin/zls 2>/dev/null
    sudo mv /tmp/zls_update/unpacked/zls /usr/local/bin/zls

    echo "Cleaning up..."
    rm -rf /tmp/zls_update
end
