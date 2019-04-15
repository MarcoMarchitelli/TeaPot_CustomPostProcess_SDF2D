using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(SDF2D_Generator_Renderer), PostProcessEvent.BeforeStack, "Custom/SDF2D/Generator")]
public class SDF2D_Generator : PostProcessEffectSettings
{
    [Header("Color")]
    public ColorParameter InsideColor = new ColorParameter();
    public ColorParameter OutsideColor = new ColorParameter();

}