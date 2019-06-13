using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[System.Serializable]
[PostProcess(typeof(SDF2D_TEST_Renderer), PostProcessEvent.BeforeStack, "Custom/SDF2D/TEST")]
public class SDF2D_TEST : PostProcessEffectSettings
{
    [Header("Color")]
    public ColorParameter InsideColor = new ColorParameter();
    public ColorParameter OutsideColor = new ColorParameter();
    [Range(0,1)]
    public FloatParameter ColorBlendStep = new FloatParameter();

    [Header("Points")]
    public FloatParameter PointsRadius = new FloatParameter();
    public IntParameter ArrayLenght = new IntParameter();
}