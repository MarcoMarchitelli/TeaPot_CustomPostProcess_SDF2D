using UnityEngine.Rendering.PostProcessing;
using UnityEngine;

public sealed class SDF2D_Teapot_Renderer : PostProcessEffectRenderer<SDF2D_Teapot>
{
    public override void Render(PostProcessRenderContext context)
    {
        Material mat = new Material(Shader.Find("Hidden/Custom/SDF2D/Teapot"));

        mat.SetColor("_InsideColor", settings.InsideColor);
        mat.SetColor("_OutsideColor", settings.OutsideColor);
        mat.SetFloat("_ColorBlendStep", settings.ColorBlendStep);

        mat.SetFloat("_PotSize", settings.PotSize);
        mat.SetFloat("_PotSmoothness", settings.PotSmoothness);

        mat.SetVector("_v0_beak_lower", settings.LowerBeakv0);
        mat.SetVector("_v1_beak_lower", settings.LowerBeakv1);
        mat.SetVector("_v2_beak_lower", settings.LowerBeakv2);
        mat.SetVector("_v1_beak_upper", settings.UpperBeakv1);
        mat.SetVector("_v2_beak_upper", settings.UpperBeakv2);
        mat.SetFloat("_BeakSize", settings.BeakSize);
        mat.SetFloat("_BeakSmoothness", settings.BeakSmoothness);

        mat.SetVector("_LidPosition", settings.LidPosition);
        mat.SetFloat("_LidSize", settings.LidSize);
        mat.SetFloat("_LidSmoothness", settings.LidSmoothness);

        mat.SetVector("_HandlePosition", settings.HandlePosition);
        mat.SetFloat("_HandleSize", settings.HandleSize);
        mat.SetFloat("_HandleSmoothness", settings.HandleSmoothness);
        mat.SetFloat("_HandleThickness", settings.HandleThickness);

        context.command.Blit(context.source, context.destination, mat);
    }
}