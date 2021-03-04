#!/usr/bin/env ruby
require 'cbor-diagnostic'
require 'cbor-deterministic'
require 'cbor-canonical'

options = ''
while /\A-([cdetu]+)\z/ === ARGV[0]
  options << $1
  ARGV.shift
end

ARGF.binmode
i = ARGF.read
while !i.empty?
  o, i = CBOR.decode_with_rest(i)
  o = o.cbor_pre_canonicalize if /c/ === options
  o = o.cbor_prepare_deterministic if /d/ === options
  out = o.cbor_diagnostic(try_decode_embedded: /e/ === options,
                          bytes_as_text: /t/ === options,
                          utf8: /u/ === options)
  if i.empty?
    puts out
  else
    print out << ', '
  end
end
