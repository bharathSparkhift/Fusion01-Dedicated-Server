Shader "Azerilo/URP Realistic Water 2"
{
    Properties
    {
        Vector1_2567DC63("Depth", Float) = 1.5
        _DeepColor("Deep Water Color", Color) = (0.1058824, 0.5372549, 0.4156863, 0.8666667)
        _ShallowColor("Shallow Water Color", Color) = (0.4705882, 0.7058824, 0.6392157, 0.4313726)
        Vector1_2244DCE3("Water Smoothness", Range(0, 1)) = 0.994
        [Normal][NoScaleOffset]Texture2D_8D156BB7("First Normal", 2D) = "bump" {}
        Vector1_CCC2E891("First Normal Strength", Range(0, 1)) = 0.392
        Vector1_27B740("First Normal Speed", Float) = 1
        Vector2_B205D3B9("First Normal Tiling", Vector) = (6, 6, 0, 0)
        [Normal][NoScaleOffset]Texture2D_8F4A6467("Second Normal", 2D) = "bump" {}
        Vector1_3D14AC92("Second Normal Strength", Range(0, 1)) = 0.696
        Vector1_CA9A9CD9("Second Normal Speed", Float) = 1
        Vector2_F8B1C5D0("Second Normal Tiling", Vector) = (6, 4, 0, 0)
        Vector1_8D629C3("Waves Frequency", Float) = 5
        Vector1_DFD163AA("Waves Height", Float) = 0.3
        Vector1_FA7B1BA("Waves Speed", Float) = 5
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            UnityTexture2D _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8D156BB7);
            float2 _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0 = Vector2_B205D3B9;
            float _Property_53fee237d89bef8b9f62200d3d55b099_Out_0 = Vector1_27B740;
            float _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2;
            Unity_Divide_float(100, _Property_53fee237d89bef8b9f62200d3d55b099_Out_0, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2);
            float _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2, _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2);
            float2 _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0, (_Divide_10f3d13800682288b01c2cc6033ebba4_Out_2.xx), _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3);
            float4 _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0 = SAMPLE_TEXTURE2D(_Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.tex, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.samplerstate, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.GetTransformedUV(_TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3));
            _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0);
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_R_4 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.r;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_G_5 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.g;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_B_6 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.b;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_A_7 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.a;
            float _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0 = Vector1_CCC2E891;
            float3 _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.xyz), _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0, _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2);
            UnityTexture2D _Property_44320be5bd526b888dcf0896b52b99e1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8F4A6467);
            float2 _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0 = Vector2_F8B1C5D0;
            float _Property_5084898b5dc23589af1b7fc68378bcde_Out_0 = Vector1_CA9A9CD9;
            float _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2;
            Unity_Divide_float(-100, _Property_5084898b5dc23589af1b7fc68378bcde_Out_0, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2);
            float _Divide_a528a61c82a5418ab99e7b0195449302_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2, _Divide_a528a61c82a5418ab99e7b0195449302_Out_2);
            float2 _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0, (_Divide_a528a61c82a5418ab99e7b0195449302_Out_2.xx), _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3);
            float4 _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0 = SAMPLE_TEXTURE2D(_Property_44320be5bd526b888dcf0896b52b99e1_Out_0.tex, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.samplerstate, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.GetTransformedUV(_TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3));
            _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0);
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_R_4 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.r;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_G_5 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.g;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_B_6 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.b;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_A_7 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.a;
            float _Property_0df8e22acd240c859822b041abbcb3cc_Out_0 = Vector1_3D14AC92;
            float3 _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.xyz), _Property_0df8e22acd240c859822b041abbcb3cc_Out_0, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2);
            float3 _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            Unity_Add_float3(_NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2, _Add_29746b0dc02fbf83ac894243a726e129_Out_2);
            float _Property_5206c8ff968df180a5481c5260ad0907_Out_0 = Vector1_2244DCE3;
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.NormalTS = _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_5206c8ff968df180a5481c5260ad0907_Out_0;
            surface.Occlusion = 1;
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            UnityTexture2D _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8D156BB7);
            float2 _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0 = Vector2_B205D3B9;
            float _Property_53fee237d89bef8b9f62200d3d55b099_Out_0 = Vector1_27B740;
            float _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2;
            Unity_Divide_float(100, _Property_53fee237d89bef8b9f62200d3d55b099_Out_0, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2);
            float _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2, _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2);
            float2 _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0, (_Divide_10f3d13800682288b01c2cc6033ebba4_Out_2.xx), _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3);
            float4 _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0 = SAMPLE_TEXTURE2D(_Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.tex, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.samplerstate, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.GetTransformedUV(_TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3));
            _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0);
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_R_4 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.r;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_G_5 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.g;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_B_6 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.b;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_A_7 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.a;
            float _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0 = Vector1_CCC2E891;
            float3 _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.xyz), _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0, _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2);
            UnityTexture2D _Property_44320be5bd526b888dcf0896b52b99e1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8F4A6467);
            float2 _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0 = Vector2_F8B1C5D0;
            float _Property_5084898b5dc23589af1b7fc68378bcde_Out_0 = Vector1_CA9A9CD9;
            float _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2;
            Unity_Divide_float(-100, _Property_5084898b5dc23589af1b7fc68378bcde_Out_0, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2);
            float _Divide_a528a61c82a5418ab99e7b0195449302_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2, _Divide_a528a61c82a5418ab99e7b0195449302_Out_2);
            float2 _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0, (_Divide_a528a61c82a5418ab99e7b0195449302_Out_2.xx), _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3);
            float4 _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0 = SAMPLE_TEXTURE2D(_Property_44320be5bd526b888dcf0896b52b99e1_Out_0.tex, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.samplerstate, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.GetTransformedUV(_TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3));
            _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0);
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_R_4 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.r;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_G_5 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.g;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_B_6 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.b;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_A_7 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.a;
            float _Property_0df8e22acd240c859822b041abbcb3cc_Out_0 = Vector1_3D14AC92;
            float3 _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.xyz), _Property_0df8e22acd240c859822b041abbcb3cc_Out_0, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2);
            float3 _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            Unity_Add_float3(_NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2, _Add_29746b0dc02fbf83ac894243a726e129_Out_2);
            float _Property_5206c8ff968df180a5481c5260ad0907_Out_0 = Vector1_2244DCE3;
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.NormalTS = _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_5206c8ff968df180a5481c5260ad0907_Out_0;
            surface.Occlusion = 1;
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8D156BB7);
            float2 _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0 = Vector2_B205D3B9;
            float _Property_53fee237d89bef8b9f62200d3d55b099_Out_0 = Vector1_27B740;
            float _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2;
            Unity_Divide_float(100, _Property_53fee237d89bef8b9f62200d3d55b099_Out_0, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2);
            float _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2, _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2);
            float2 _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0, (_Divide_10f3d13800682288b01c2cc6033ebba4_Out_2.xx), _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3);
            float4 _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0 = SAMPLE_TEXTURE2D(_Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.tex, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.samplerstate, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.GetTransformedUV(_TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3));
            _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0);
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_R_4 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.r;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_G_5 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.g;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_B_6 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.b;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_A_7 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.a;
            float _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0 = Vector1_CCC2E891;
            float3 _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.xyz), _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0, _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2);
            UnityTexture2D _Property_44320be5bd526b888dcf0896b52b99e1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8F4A6467);
            float2 _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0 = Vector2_F8B1C5D0;
            float _Property_5084898b5dc23589af1b7fc68378bcde_Out_0 = Vector1_CA9A9CD9;
            float _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2;
            Unity_Divide_float(-100, _Property_5084898b5dc23589af1b7fc68378bcde_Out_0, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2);
            float _Divide_a528a61c82a5418ab99e7b0195449302_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2, _Divide_a528a61c82a5418ab99e7b0195449302_Out_2);
            float2 _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0, (_Divide_a528a61c82a5418ab99e7b0195449302_Out_2.xx), _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3);
            float4 _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0 = SAMPLE_TEXTURE2D(_Property_44320be5bd526b888dcf0896b52b99e1_Out_0.tex, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.samplerstate, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.GetTransformedUV(_TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3));
            _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0);
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_R_4 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.r;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_G_5 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.g;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_B_6 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.b;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_A_7 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.a;
            float _Property_0df8e22acd240c859822b041abbcb3cc_Out_0 = Vector1_3D14AC92;
            float3 _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.xyz), _Property_0df8e22acd240c859822b041abbcb3cc_Out_0, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2);
            float3 _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            Unity_Add_float3(_NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2, _Add_29746b0dc02fbf83ac894243a726e129_Out_2);
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.NormalTS = _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            UnityTexture2D _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8D156BB7);
            float2 _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0 = Vector2_B205D3B9;
            float _Property_53fee237d89bef8b9f62200d3d55b099_Out_0 = Vector1_27B740;
            float _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2;
            Unity_Divide_float(100, _Property_53fee237d89bef8b9f62200d3d55b099_Out_0, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2);
            float _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2, _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2);
            float2 _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0, (_Divide_10f3d13800682288b01c2cc6033ebba4_Out_2.xx), _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3);
            float4 _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0 = SAMPLE_TEXTURE2D(_Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.tex, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.samplerstate, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.GetTransformedUV(_TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3));
            _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0);
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_R_4 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.r;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_G_5 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.g;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_B_6 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.b;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_A_7 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.a;
            float _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0 = Vector1_CCC2E891;
            float3 _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.xyz), _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0, _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2);
            UnityTexture2D _Property_44320be5bd526b888dcf0896b52b99e1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8F4A6467);
            float2 _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0 = Vector2_F8B1C5D0;
            float _Property_5084898b5dc23589af1b7fc68378bcde_Out_0 = Vector1_CA9A9CD9;
            float _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2;
            Unity_Divide_float(-100, _Property_5084898b5dc23589af1b7fc68378bcde_Out_0, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2);
            float _Divide_a528a61c82a5418ab99e7b0195449302_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2, _Divide_a528a61c82a5418ab99e7b0195449302_Out_2);
            float2 _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0, (_Divide_a528a61c82a5418ab99e7b0195449302_Out_2.xx), _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3);
            float4 _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0 = SAMPLE_TEXTURE2D(_Property_44320be5bd526b888dcf0896b52b99e1_Out_0.tex, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.samplerstate, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.GetTransformedUV(_TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3));
            _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0);
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_R_4 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.r;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_G_5 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.g;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_B_6 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.b;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_A_7 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.a;
            float _Property_0df8e22acd240c859822b041abbcb3cc_Out_0 = Vector1_3D14AC92;
            float3 _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.xyz), _Property_0df8e22acd240c859822b041abbcb3cc_Out_0, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2);
            float3 _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            Unity_Add_float3(_NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2, _Add_29746b0dc02fbf83ac894243a726e129_Out_2);
            float _Property_5206c8ff968df180a5481c5260ad0907_Out_0 = Vector1_2244DCE3;
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.NormalTS = _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_5206c8ff968df180a5481c5260ad0907_Out_0;
            surface.Occlusion = 1;
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8D156BB7);
            float2 _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0 = Vector2_B205D3B9;
            float _Property_53fee237d89bef8b9f62200d3d55b099_Out_0 = Vector1_27B740;
            float _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2;
            Unity_Divide_float(100, _Property_53fee237d89bef8b9f62200d3d55b099_Out_0, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2);
            float _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b8be9eb8fc1a438f87a3eea4492b67c5_Out_2, _Divide_10f3d13800682288b01c2cc6033ebba4_Out_2);
            float2 _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_1b5e358a055f1c80b1a7f3dce4b65769_Out_0, (_Divide_10f3d13800682288b01c2cc6033ebba4_Out_2.xx), _TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3);
            float4 _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0 = SAMPLE_TEXTURE2D(_Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.tex, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.samplerstate, _Property_713f1adb9a94188e9a6cba28b8118a34_Out_0.GetTransformedUV(_TilingAndOffset_b543b91af6605a839344dda5db28b2dd_Out_3));
            _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0);
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_R_4 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.r;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_G_5 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.g;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_B_6 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.b;
            float _SampleTexture2D_2464c7e332add28190281a23bddcee73_A_7 = _SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.a;
            float _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0 = Vector1_CCC2E891;
            float3 _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_2464c7e332add28190281a23bddcee73_RGBA_0.xyz), _Property_b7a1ed956c0a9d8eb1bd267cb9d14aab_Out_0, _NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2);
            UnityTexture2D _Property_44320be5bd526b888dcf0896b52b99e1_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_8F4A6467);
            float2 _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0 = Vector2_F8B1C5D0;
            float _Property_5084898b5dc23589af1b7fc68378bcde_Out_0 = Vector1_CA9A9CD9;
            float _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2;
            Unity_Divide_float(-100, _Property_5084898b5dc23589af1b7fc68378bcde_Out_0, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2);
            float _Divide_a528a61c82a5418ab99e7b0195449302_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_b67f0f81d7d3558ea192d40e4df3d92b_Out_2, _Divide_a528a61c82a5418ab99e7b0195449302_Out_2);
            float2 _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_2d2d0f4ffd170b8ca1609c7af10e554a_Out_0, (_Divide_a528a61c82a5418ab99e7b0195449302_Out_2.xx), _TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3);
            float4 _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0 = SAMPLE_TEXTURE2D(_Property_44320be5bd526b888dcf0896b52b99e1_Out_0.tex, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.samplerstate, _Property_44320be5bd526b888dcf0896b52b99e1_Out_0.GetTransformedUV(_TilingAndOffset_b52a6b0ae9d80f87a280868b360486df_Out_3));
            _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0);
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_R_4 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.r;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_G_5 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.g;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_B_6 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.b;
            float _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_A_7 = _SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.a;
            float _Property_0df8e22acd240c859822b041abbcb3cc_Out_0 = Vector1_3D14AC92;
            float3 _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2;
            Unity_NormalStrength_float((_SampleTexture2D_87987838bbedc38097fcf7a5b908c018_RGBA_0.xyz), _Property_0df8e22acd240c859822b041abbcb3cc_Out_0, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2);
            float3 _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            Unity_Add_float3(_NormalStrength_a05dbe9847d0e886a37bfaf1ef86f8ba_Out_2, _NormalStrength_b26f94b5a65ed28896970a5b219a94a6_Out_2, _Add_29746b0dc02fbf83ac894243a726e129_Out_2);
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.NormalTS = _Add_29746b0dc02fbf83ac894243a726e129_Out_2;
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float Vector1_2567DC63;
        float4 _DeepColor;
        float4 _ShallowColor;
        float Vector1_2244DCE3;
        float4 Texture2D_8D156BB7_TexelSize;
        float Vector1_CCC2E891;
        float Vector1_27B740;
        float2 Vector2_B205D3B9;
        float4 Texture2D_8F4A6467_TexelSize;
        float Vector1_3D14AC92;
        float Vector1_CA9A9CD9;
        float2 Vector2_F8B1C5D0;
        float Vector1_8D629C3;
        float Vector1_DFD163AA;
        float Vector1_FA7B1BA;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_8D156BB7);
        SAMPLER(samplerTexture2D_8D156BB7);
        TEXTURE2D(Texture2D_8F4A6467);
        SAMPLER(samplerTexture2D_8F4A6467);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_86bf1774676ff4868f0ba521d250930a_R_1 = IN.ObjectSpacePosition[0];
            float _Split_86bf1774676ff4868f0ba521d250930a_G_2 = IN.ObjectSpacePosition[1];
            float _Split_86bf1774676ff4868f0ba521d250930a_B_3 = IN.ObjectSpacePosition[2];
            float _Split_86bf1774676ff4868f0ba521d250930a_A_4 = 0;
            float _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0 = Vector1_FA7B1BA;
            float _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2;
            Unity_Divide_float(100, _Property_b4aa711109a0628dbe6a6034ee5a987b_Out_0, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2);
            float _Divide_3c755facc325e78eb7613ea88e86a831_Out_2;
            Unity_Divide_float(IN.TimeParameters.x, _Divide_189b3455df1ba48397b0f30adcef3a2b_Out_2, _Divide_3c755facc325e78eb7613ea88e86a831_Out_2);
            float2 _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), (_Divide_3c755facc325e78eb7613ea88e86a831_Out_2.xx), _TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3);
            float _Property_4b024e1ab4e80888974707c97a29da95_Out_0 = Vector1_8D629C3;
            float _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_f3f923f78c9c068f8b21c5a1e9eb13a0_Out_3, _Property_4b024e1ab4e80888974707c97a29da95_Out_0, _GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2);
            float _Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0 = Vector1_DFD163AA;
            float _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2;
            Unity_Divide_float(_Property_a0083d1eb918cd889c74e138b1d20fa6_Out_0, 10, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2);
            float _Multiply_d48ad920a09595888547dc3661d22fca_Out_2;
            Unity_Multiply_float_float(_GradientNoise_9eaf41b203791487ad738e3ea2f1b899_Out_2, _Divide_e32225aab2aa4a8f9750c17aafd9f90b_Out_2, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2);
            float4 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4;
            float3 _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            float2 _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6;
            Unity_Combine_float(_Split_86bf1774676ff4868f0ba521d250930a_R_1, _Multiply_d48ad920a09595888547dc3661d22fca_Out_2, _Split_86bf1774676ff4868f0ba521d250930a_B_3, 0, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGBA_4, _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5, _Combine_0a304a49608eca849568c0ecf8d39ef4_RG_6);
            description.Position = _Combine_0a304a49608eca849568c0ecf8d39ef4_RGB_5;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_5a3355d39c7e10809bb5b39616d96721_Out_0 = _ShallowColor;
            float4 _Property_92667555aaddbb85bee6b0903b8b269d_Out_0 = _DeepColor;
            float _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1;
            Unity_SceneDepth_Linear01_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1);
            float _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2;
            Unity_Multiply_float_float(_SceneDepth_ce6ab218fd2d7c82aa22b30b5066d761_Out_1, _ProjectionParams.z, _Multiply_f4afa1949841d286870116c0a6e72a28_Out_2);
            float4 _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0 = IN.ScreenPosition;
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_R_1 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[0];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_G_2 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[1];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_B_3 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[2];
            float _Split_ebc6f67f3d3da88493a84f6f392464d1_A_4 = _ScreenPosition_c8fbe1680678e38ebfc2297a3d40a811_Out_0[3];
            float _Property_556c2e483e0d158288aa6584a674ebeb_Out_0 = Vector1_2567DC63;
            float _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2;
            Unity_Add_float(_Split_ebc6f67f3d3da88493a84f6f392464d1_A_4, _Property_556c2e483e0d158288aa6584a674ebeb_Out_0, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2);
            float _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2;
            Unity_Subtract_float(_Multiply_f4afa1949841d286870116c0a6e72a28_Out_2, _Add_9ccaf4bf5694c18c8947e471d4752217_Out_2, _Subtract_9969072ede3fe685a53cce85dea9e186_Out_2);
            float _Clamp_47e459127b34068c922f860d2dd940ae_Out_3;
            Unity_Clamp_float(_Subtract_9969072ede3fe685a53cce85dea9e186_Out_2, 0, 1, _Clamp_47e459127b34068c922f860d2dd940ae_Out_3);
            float4 _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3;
            Unity_Lerp_float4(_Property_5a3355d39c7e10809bb5b39616d96721_Out_0, _Property_92667555aaddbb85bee6b0903b8b269d_Out_0, (_Clamp_47e459127b34068c922f860d2dd940ae_Out_3.xxxx), _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3);
            float _Split_4fa5abba8825d78a8ae14c3fda482890_R_1 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[0];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_G_2 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[1];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_B_3 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[2];
            float _Split_4fa5abba8825d78a8ae14c3fda482890_A_4 = _Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3[3];
            surface.BaseColor = (_Lerp_adbc96d97107888a926c4adcb1a0098e_Out_3.xyz);
            surface.Alpha = _Split_4fa5abba8825d78a8ae14c3fda482890_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
}