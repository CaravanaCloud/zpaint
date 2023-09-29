const r = @import("raylib");
const std = @import("std");
const print = std.debug.print;
const Color = r.Color;

const allocator = std.heap.page_allocator;

const WINDOW_WIDTH = 960;
const WINDOW_HEIGHT = 540;

pub fn main() !void {
    r.initWindow(960, 540, "zPaint");

    r.setTargetFPS(60);
    defer r.closeWindow();
    var buf: [8096]u8 = undefined;

    var target = r.loadRenderTexture(WINDOW_WIDTH - 50, WINDOW_HEIGHT - 50);
    r.beginTextureMode(target);
    r.clearBackground(r.Color.white);
    r.endTextureMode();

    while (!r.windowShouldClose()) {

        // Update
        var mouse_pos = r.getMousePosition();
        var mouse_click = r.isMouseButtonDown(r.MouseButton.mouse_button_left);

        if(mouse_click) {
            r.beginTextureMode(target);
            r.drawCircle(@intFromFloat(mouse_pos.x), @intFromFloat(mouse_pos.y), 10, r.Color.red);
            r.endTextureMode();
        }

        // Drawing
        r.beginDrawing();
        r.clearBackground(r.Color.white);
        r.drawTextureRec(
            target.texture, 
            r.Rectangle { 
                .x = 0, 
                .y = 0, 
                .width = @floatFromInt(target.texture.width), 
                .height = @floatFromInt(-target.texture.height)
            },
            .{
                .x = 0, 
                .y = 0
            },
            r.Color.white
        );

        const debug_text = try std.fmt.bufPrintZ(&buf,
            "X: {d}\n\nY: {d}\n\nClick: {s}",
            .{ 
                @trunc(mouse_pos.x), 
                @trunc(mouse_pos.y), 
                if (mouse_click) "true" else "false"
            },
        );

        r.drawText(@ptrCast(debug_text), 10, 0, 24, r.Color.black);

        var fps = r.getFPS();

        const fps_text = try std.fmt.bufPrintZ(&buf,
            "FPS: {d}",
            .{ fps },
        );

        r.drawText(@ptrCast(fps_text), 10, WINDOW_HEIGHT - 30, 24, r.Color.black);

        r.endDrawing();
    }
}