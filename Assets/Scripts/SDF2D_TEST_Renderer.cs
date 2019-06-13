using UnityEngine.Rendering.PostProcessing;
using UnityEngine;

public sealed class SDF2D_TEST_Renderer : PostProcessEffectRenderer<SDF2D_TEST>
{
    public override void Render(PostProcessRenderContext context)
    {
        Material mat = new Material(Shader.Find("Hidden/Custom/SDF2D/TEST"));

        mat.SetColor("_InsideColor", settings.InsideColor);
        mat.SetColor("_OutsideColor", settings.OutsideColor);
        mat.SetFloat("_ColorBlendStep", settings.ColorBlendStep);

        mat.SetFloat("_PointsRadius", settings.PointsRadius);
        mat.SetInt("_ArrayLenght", settings.ArrayLenght);

        Input_Test.arrayLenght = settings.ArrayLenght;

        mat.SetVectorArray("_PointsArray", Input_Test.registeredPoints);

        context.command.Blit(context.source, context.destination, mat);
    }
}