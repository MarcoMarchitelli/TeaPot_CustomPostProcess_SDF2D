using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(SDF2D_Teapot_Renderer), PostProcessEvent.BeforeStack, "Custom/SDF2D/Teapot")]
public class SDF2D_Teapot : PostProcessEffectSettings
{
    [Header("Color")]
    public ColorParameter InsideColor = new ColorParameter();
    public ColorParameter OutsideColor = new ColorParameter();
    [Range(0,1)]
    public FloatParameter ColorBlendStep = new FloatParameter();

    [Header("Pot")]
    [Range(0,1)]
    public FloatParameter PotSize = new FloatParameter();
    [Range(0, 0.1f)]
    public FloatParameter PotSmoothness = new FloatParameter();

    [Header("Beak")]
    public Vector2Parameter LowerBeakv0 = new Vector2Parameter();
    public Vector2Parameter LowerBeakv1 = new Vector2Parameter();
    public Vector2Parameter LowerBeakv2 = new Vector2Parameter();
    public Vector2Parameter UpperBeakv1 = new Vector2Parameter();
    public Vector2Parameter UpperBeakv2 = new Vector2Parameter();
    [Range(0, 1)]
    public FloatParameter BeakSize = new FloatParameter();
    [Range(0, 0.1f)]
    public FloatParameter BeakSmoothness = new FloatParameter();

    [Header("Lid")]
    public Vector2Parameter LidPosition = new Vector2Parameter();
    [Range(0, 1)]
    public FloatParameter LidSize = new FloatParameter();
    [Range(0, 0.1f)]
    public FloatParameter LidSmoothness = new FloatParameter();

    [Header("Handle")]
    public Vector2Parameter HandlePosition = new Vector2Parameter();
    [Range(0, 1)]
    public FloatParameter HandleSize = new FloatParameter();
    [Range(0, 0.1f)]
    public FloatParameter HandleSmoothness = new FloatParameter();
    [Range(0, 0.1f)]
    public FloatParameter HandleThickness = new FloatParameter();
}