 
===========================
The Linux bootsplash-packer
===========================

:Date: November, 2017
:Author: Max Staudt <mstaudt@suse.de>


Usage: bootsplash-packer [OPTIONS] outfile

Options, executed in order given:
  -h, --help                   Print this help message

  --bg_red <u8>                Background color (red part)
  --bg_green <u8>              Background color (green part)
  --bg_blue <u8>               Background color (blue part)
  --bg_reserved <u8>           (do not use)
  --frame_ms <u16>             Minimum milliseconds between animation steps

  --picture                    Start describing the next picture
  --pic_width <u16>            Picture width in pixels
  --pic_height <u16>           Picture height in pixels
  --pic_position <u8>             Coarse picture placement:
                                  0x00 - Top left
                                  0x01 - Top
                                  0x02 - Top right
                                  0x03 - Right
                                  0x04 - Bottom right
                                  0x05 - Bottom
                                  0x06 - Bottom left
                                  0x07 - Left

                                Flags:
                                 0x10 - Calculate offset from corner towards center,
                                         rather than from center towards corner
  --pic_position_offset <u16>  Distance from base position in pixels
  --pic_anim_type <u8>         Animation type:
                                 0 - None
                                 1 - Forward loop
  --pic_anim_loop <u8>         Loop point for animation

  --blob <filename>            Include next data stream
  --blob_type <u16>            Type of data
  --blob_picture_id <u8>       Picture to associate this blob with, starting at 0
                                 (default: number of last --picture)

This tool will write Little Endian (LE) files.

