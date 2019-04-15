using UnityEngine.Rendering.PostProcessing;
using UnityEngine;

public sealed class SDF2D_Generator_Renderer : PostProcessEffectRenderer<SDF2D_Generator>
{
    public override void Render(PostProcessRenderContext context)
    {
        Material mat = new Material(Shader.Find("Hidden/Custom/SDF2D/Generator"));

        mat.SetColor("_InsideColor", settings.InsideColor);
        mat.SetColor("_OutsideColor", settings.OutsideColor);

        context.command.Blit(context.source, context.destination, mat);
    }
}