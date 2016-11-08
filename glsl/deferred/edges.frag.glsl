#version 100
precision highp float;
precision highp int;

#define NUM_GBUFFERS 3
#define NUM_CEL_CUTS 7
#define gb(i) (texture2D(u_gbufs[i], v_uv).xyz)
#define round(n) (floor((n) + 0.5))
#define color_at_offset(i, j) (texture2D(u_depth, v_uv + vec2(i, j) / vec2(width, height)))
#define PRODUCT_AT_OFFSET(i, j, kernel) (dot(vec4(1), color_at_offset(i, j) * float(kernel[i][j])))

uniform sampler2D u_gbufs[NUM_GBUFFERS];
uniform sampler2D u_depth;

varying vec2 v_uv;

void main() {
    int width = 800;
    int height = 600;

    mat2 gx = mat2(
         1,  0,
         0, -1
    );

    mat2 gy = mat2(
        0, -1,
        1,  0
    );

    float gx_conv = PRODUCT_AT_OFFSET(0, 0, gx) +
                    PRODUCT_AT_OFFSET(0, 1, gx) +

                    PRODUCT_AT_OFFSET(1, 0, gx) +
                    PRODUCT_AT_OFFSET(1, 1, gx) ;

    float gy_conv = PRODUCT_AT_OFFSET(0, 0, gy) +
                    PRODUCT_AT_OFFSET(0, 1, gy) +

                    PRODUCT_AT_OFFSET(1, 0, gy) +
                    PRODUCT_AT_OFFSET(1, 1, gy) ;

    if (gx_conv + gy_conv > 0.5) {
       gl_FragColor = vec4(0, 0, 0, 1);
    }
}
