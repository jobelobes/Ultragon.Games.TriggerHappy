using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Design;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using DeferredRenderingTest;

namespace DeferredRenderingTest
{
    class DeferredRenderer : Microsoft.Xna.Framework.DrawableGameComponent
    {
        #region Variables
        private Camera m_pCamera;
        private QuadRenderComponent m_pQuadRenderer;
        private Scene m_pScene;

        private RenderTarget2D m_rColorRT;
        private RenderTarget2D m_rNormalRT;
        private RenderTarget2D m_rDepthRT;
        private RenderTarget2D m_rLightRT;

        private Effect m_pClearBufferEffect;
        private Effect m_pDirectionalLightEffect;
        private Effect m_pCombineEffect;
        private Effect m_pPointLightEffect;
        private Effect m_pSpotLightEffect;

        private Model m_pSphereModel;
        private Model m_pConeModel;

        private SpriteBatch m_pSpriteBatch;

        private Vector2 m_vHalfPixel;
        #endregion

        #region Properties

        #endregion

        #region Constructors and Deconstructors
        public DeferredRenderer(Game game)
            : base(game)
        {
            this.m_pScene = new Scene(game);
        }
        #endregion

        #region Methods
        private void SetGBuffer()
        {
            this.GraphicsDevice.SetRenderTarget(0, this.m_rColorRT);
            this.GraphicsDevice.SetRenderTarget(1, this.m_rNormalRT);
            this.GraphicsDevice.SetRenderTarget(2, this.m_rDepthRT);
        }

        private void ResolveGBuffer()
        {
            this.GraphicsDevice.SetRenderTarget(0, null);
            this.GraphicsDevice.SetRenderTarget(1, null);
            this.GraphicsDevice.SetRenderTarget(2, null);
        }

        private void ClearBuffer()
        {
            this.m_pClearBufferEffect.Begin();
            this.m_pClearBufferEffect.Techniques[0].Passes[0].Begin();
            this.m_pQuadRenderer.Render(Vector2.One * -1, Vector2.One);
            this.m_pClearBufferEffect.Techniques[0].Passes[0].End();
            this.m_pClearBufferEffect.End();
        }

        private void DrawDirectionalLight(Vector3 lightDirection, Color color)
        {
            //set all the parameters
            this.m_pDirectionalLightEffect.Parameters["colorMap"].SetValue(this.m_rColorRT.GetTexture());
            this.m_pDirectionalLightEffect.Parameters["normalMap"].SetValue(this.m_rNormalRT.GetTexture());
            this.m_pDirectionalLightEffect.Parameters["depthMap"].SetValue(this.m_rDepthRT.GetTexture());
            this.m_pDirectionalLightEffect.Parameters["lightDirection"].SetValue(lightDirection);
            this.m_pDirectionalLightEffect.Parameters["lightColor"].SetValue(color.ToVector3());
            this.m_pDirectionalLightEffect.Parameters["cameraPosition"].SetValue(this.m_pCamera.Position);
            this.m_pDirectionalLightEffect.Parameters["InverseViewProjection"].SetValue(Matrix.Invert(this.m_pCamera.View * this.m_pCamera.Projection));
            this.m_pDirectionalLightEffect.Parameters["halfPixel"].SetValue(this.m_vHalfPixel);

            this.m_pDirectionalLightEffect.Begin();
            this.m_pDirectionalLightEffect.Techniques[0].Passes[0].Begin();
            this.m_pQuadRenderer.Render(Vector2.One * -1, Vector2.One);
            this.m_pDirectionalLightEffect.Techniques[0].Passes[0].End();
            this.m_pDirectionalLightEffect.End();
        }

        private void DrawPointLight(Vector3 lightPosition, Color color, float lightRadius, float lightIntensity)
        {
            //G buffer parameters
            this.m_pPointLightEffect.Parameters["diffuseMap"].SetValue(this.m_rColorRT.GetTexture());
            this.m_pPointLightEffect.Parameters["normalMap"].SetValue(this.m_rNormalRT.GetTexture());
            this.m_pPointLightEffect.Parameters["depthMap"].SetValue(this.m_rDepthRT.GetTexture());

            //Compute sphere world matrix
            //scaling according to light radius and translating it based on light position
            Matrix sphereWorldMatrix = Matrix.CreateScale(lightRadius) * Matrix.CreateTranslation(lightPosition);
            this.m_pPointLightEffect.Parameters["World"].SetValue(sphereWorldMatrix);
            this.m_pPointLightEffect.Parameters["View"].SetValue(this.m_pCamera.View);
            this.m_pPointLightEffect.Parameters["Projection"].SetValue(this.m_pCamera.Projection);

            //light position
            this.m_pPointLightEffect.Parameters["lightPosition"].SetValue(lightPosition);
            this.m_pPointLightEffect.Parameters["lightColor"].SetValue(color.ToVector3());
            this.m_pPointLightEffect.Parameters["lightRadius"].SetValue(lightRadius);
            this.m_pPointLightEffect.Parameters["lightIntensity"].SetValue(lightIntensity);

            //camera position
            this.m_pPointLightEffect.Parameters["cameraPosition"].SetValue(this.m_pCamera.Position);
            this.m_pPointLightEffect.Parameters["InverseViewProjection"].SetValue(Matrix.Invert(this.m_pCamera.View * this.m_pCamera.Projection));
            this.m_pPointLightEffect.Parameters["halfPixel"].SetValue(this.m_vHalfPixel);

            //calculate the distance between the camera and light center
            float cameraToCenter = Vector3.Distance(this.m_pCamera.Position, lightPosition);

            //if we are inside the light volume, draw the sphere's inside face
            if (cameraToCenter < lightRadius)
                this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullClockwiseFace;
            else
                this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullCounterClockwiseFace;

            this.m_pPointLightEffect.Begin();
            this.m_pPointLightEffect.Techniques[0].Passes[0].Begin();
            foreach (ModelMesh mesh in this.m_pSphereModel.Meshes)
            {
                foreach (ModelMeshPart meshPart in mesh.MeshParts)
                {
                    this.Game.GraphicsDevice.VertexDeclaration = meshPart.VertexDeclaration;
                    this.Game.GraphicsDevice.Vertices[0].SetSource(mesh.VertexBuffer, meshPart.StreamOffset, meshPart.VertexStride);
                    this.Game.GraphicsDevice.Indices = mesh.IndexBuffer;
                    this.Game.GraphicsDevice.DrawIndexedPrimitives(PrimitiveType.TriangleList, meshPart.BaseVertex, 0, meshPart.NumVertices, meshPart.StartIndex, meshPart.PrimitiveCount);
                }
            }
            this.m_pPointLightEffect.Techniques[0].Passes[0].End();
            this.m_pPointLightEffect.End();
            this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullCounterClockwiseFace;
        }

        private void DrawSpotLight(Vector3 position, Vector3 pointTo, Color color, float lightRadius, float theta, float phi, float spotPower)
        {
            //G buffer parameters
            this.m_pSpotLightEffect.Parameters["diffuseMap"].SetValue(this.m_rColorRT.GetTexture());
            this.m_pSpotLightEffect.Parameters["normalMap"].SetValue(this.m_rNormalRT.GetTexture());
            this.m_pSpotLightEffect.Parameters["depthMap"].SetValue(this.m_rDepthRT.GetTexture());
            this.m_pSpotLightEffect.Parameters["halfPixel"].SetValue(this.m_vHalfPixel);

            //World parameters
            Vector3 direction = Vector3.Normalize(position - pointTo);
            Matrix coneMatrix = Matrix.CreateScale(lightRadius) * Matrix.CreateFromQuaternion(new Quaternion(direction, 1.0f)) * Matrix.CreateTranslation(position);

            this.m_pSpotLightEffect.Parameters["World"].SetValue(coneMatrix);
            this.m_pSpotLightEffect.Parameters["View"].SetValue(this.m_pCamera.View);
            this.m_pSpotLightEffect.Parameters["Projection"].SetValue(this.m_pCamera.Projection);
            
            //Camera parameters
            this.m_pSpotLightEffect.Parameters["cameraPosition"].SetValue(this.m_pCamera.Position);
            this.m_pSpotLightEffect.Parameters["InverseViewProjection"].SetValue(Matrix.Invert(this.m_pCamera.View * this.m_pCamera.Projection));

            //Light paremeters
            this.m_pSpotLightEffect.Parameters["lightDiffuseColor"].SetValue(color.ToVector3());
            this.m_pSpotLightEffect.Parameters["lightPosition"].SetValue(position);
            this.m_pSpotLightEffect.Parameters["lightDirection"].SetValue(direction);
            this.m_pSpotLightEffect.Parameters["lightRadius"].SetValue(lightRadius);
            this.m_pSpotLightEffect.Parameters["theta"].SetValue(theta);
            this.m_pSpotLightEffect.Parameters["phi"].SetValue(phi);
            this.m_pSpotLightEffect.Parameters["spotPower"].SetValue(spotPower);

            //calculate the distance between the camera and light center
            float cameraToCenter = Vector3.Distance(this.m_pCamera.Position, position);

            //if we are inside the light volume, draw the sphere's inside face
            if (cameraToCenter < lightRadius)
                this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullClockwiseFace;
            else
                this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullCounterClockwiseFace;

            this.Game.GraphicsDevice.RenderState.DepthBufferEnable = false;
            this.Game.GraphicsDevice.RenderState.CullMode = CullMode.None; 

            this.m_pSpotLightEffect.Begin();
            this.m_pSpotLightEffect.Techniques[0].Passes[0].Begin();
            foreach (ModelMesh mesh in this.m_pSphereModel.Meshes)
            {
                foreach (ModelMeshPart meshPart in mesh.MeshParts)
                {
                    this.Game.GraphicsDevice.VertexDeclaration = meshPart.VertexDeclaration;
                    this.Game.GraphicsDevice.Vertices[0].SetSource(mesh.VertexBuffer, meshPart.StreamOffset, meshPart.VertexStride);
                    this.Game.GraphicsDevice.Indices = mesh.IndexBuffer;
                    this.Game.GraphicsDevice.DrawIndexedPrimitives(PrimitiveType.TriangleList, meshPart.BaseVertex, 0, meshPart.NumVertices, meshPart.StartIndex, meshPart.PrimitiveCount);
                }
            }
            this.m_pSpotLightEffect.Techniques[0].Passes[0].End();
            this.m_pSpotLightEffect.End();
            this.Game.GraphicsDevice.RenderState.CullMode = CullMode.CullCounterClockwiseFace;
            this.Game.GraphicsDevice.RenderState.DepthBufferWriteEnable = true;
        }

        private void DrawLights(GameTime gameTime)
        {
            this.Game.GraphicsDevice.SetRenderTarget(0, this.m_rLightRT);
            
            //clearing the components
            this.Game.GraphicsDevice.Clear(Color.TransparentBlack);
            this.Game.GraphicsDevice.RenderState.AlphaBlendEnable = true;

            //Setting the blend state
            this.Game.GraphicsDevice.RenderState.AlphaBlendOperation = BlendFunction.Add;
            this.Game.GraphicsDevice.RenderState.SourceBlend = Blend.One;
            this.Game.GraphicsDevice.RenderState.DestinationBlend = Blend.One;

            //Setting the alpha channel blend
            this.Game.GraphicsDevice.RenderState.SeparateAlphaBlendEnabled = false;
            this.Game.GraphicsDevice.RenderState.DepthBufferEnable = false;

            //Draw some directional lights
            this.DrawDirectionalLight(new Vector3(0, -1, 0), Color.DimGray);
            this.DrawDirectionalLight(new Vector3(-1, -1, 0), Color.White);
            this.DrawDirectionalLight(new Vector3(1, 0, 0), Color.SkyBlue);
            this.DrawSpotLight(new Vector3(50, 10, 50), Vector3.Zero, Color.White, 100, 10, 100, 2);
            this.DrawPointLight(new Vector3(50 * (float)Math.Sin(gameTime.TotalGameTime.TotalSeconds), 10, 50 * (float)Math.Cos(gameTime.TotalGameTime.TotalSeconds)), Color.Red, 100, 4);
            
            this.Game.GraphicsDevice.RenderState.AlphaBlendEnable = false;
            this.Game.GraphicsDevice.SetRenderTarget(0, null);

            //int halfWidth = this.Game.GraphicsDevice.Viewport.Width / 2;
            //int halfHeight = this.Game.GraphicsDevice.Viewport.Height / 2;

            //this.m_pSpriteBatch.Begin(SpriteBlendMode.None);
            //this.m_pSpriteBatch.Draw(this.m_rColorRT.GetTexture(), new Rectangle(0, 0, halfWidth, halfHeight), Color.White);
            //this.m_pSpriteBatch.Draw(this.m_rLightRT.GetTexture(), new Rectangle(0, halfHeight, halfWidth, halfHeight), Color.White);
            //this.m_pSpriteBatch.End();

            //Set final parameters
            this.Game.GraphicsDevice.Clear(Color.Black);
            this.m_pCombineEffect.Parameters["DiffuseMap"].SetValue(this.m_rColorRT.GetTexture());
            this.m_pCombineEffect.Parameters["LightMap"].SetValue(this.m_rLightRT.GetTexture());
            this.m_pCombineEffect.Parameters["halfPixel"].SetValue(this.m_vHalfPixel);

            this.m_pCombineEffect.Begin();
            this.m_pCombineEffect.Techniques[0].Passes[0].Begin();
            this.m_pQuadRenderer.Render(Vector2.One * -1, Vector2.One);
            this.m_pCombineEffect.Techniques[0].Passes[0].End();
            this.m_pCombineEffect.End();
        }
        #endregion

        #region Overriden Methods
        public override void Initialize()
        {
            base.Initialize();

            this.m_pCamera = new Camera(this.Game);
            this.m_pQuadRenderer = new QuadRenderComponent(this.Game);

            this.Game.Components.Add(this.m_pCamera);
            this.Game.Components.Add(this.m_pQuadRenderer);

        }

        protected override void LoadContent()
        {
            base.LoadContent();

            this.m_pScene.InitializeScene();

            int backBufferWidth = this.GraphicsDevice.PresentationParameters.BackBufferWidth;
            int backBufferHeight = this.GraphicsDevice.PresentationParameters.BackBufferHeight;

            this.m_rColorRT = new RenderTarget2D(this.GraphicsDevice, backBufferWidth, backBufferHeight, 1, SurfaceFormat.Color);
            this.m_rNormalRT = new RenderTarget2D(this.GraphicsDevice, backBufferWidth, backBufferHeight, 1, SurfaceFormat.Color);
            this.m_rDepthRT = new RenderTarget2D(this.GraphicsDevice, backBufferWidth, backBufferHeight, 1, SurfaceFormat.Single);
            this.m_rLightRT = new RenderTarget2D(this.GraphicsDevice, backBufferWidth, backBufferHeight, 1, SurfaceFormat.Color);

            this.m_pClearBufferEffect = this.Game.Content.Load<Effect>("ClearGBuffer");
            this.m_pDirectionalLightEffect = this.Game.Content.Load<Effect>("DirectionalLight");
            this.m_pCombineEffect = this.Game.Content.Load<Effect>("CombineFinal");
            this.m_pPointLightEffect = this.Game.Content.Load<Effect>("PointLight");
            this.m_pSpotLightEffect = this.Game.Content.Load<Effect>("SpotLight");

            this.m_pSphereModel = this.Game.Content.Load<Model>("Models\\Sphere");
            this.m_pConeModel = this.Game.Content.Load<Model>("cone");

            this.m_pSpriteBatch = new SpriteBatch(this.Game.GraphicsDevice);

            this.m_vHalfPixel.X = 0.5f / (float)this.Game.GraphicsDevice.PresentationParameters.BackBufferWidth;
            this.m_vHalfPixel.Y = 0.5f / (float)this.Game.GraphicsDevice.PresentationParameters.BackBufferHeight;
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            this.SetGBuffer();
            this.Game.GraphicsDevice.Clear(Color.Gray);
            //this.ClearBuffer();
            this.m_pScene.DrawScene(this.m_pCamera);
            this.ResolveGBuffer();

            this.Game.GraphicsDevice.Clear(Color.Black);
            this.DrawLights(gameTime);
            base.Draw(gameTime);
        }
        #endregion
    }
}
