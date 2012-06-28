using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;
using Microsoft.Xna.Framework.Net;
using Microsoft.Xna.Framework.Storage;

namespace DeferredRenderingTest
{
    class Scene
    {
        #region Variables
        private Game m_pGame;
        private Model m_mShipModel;
        #endregion

        #region Constructors and Deconstructors
        public Scene(Game game)
        {
            this.m_pGame = game;
        }
        #endregion

        #region Methods
        public void InitializeScene()
        {
            this.m_mShipModel = this.m_pGame.Content.Load<Model>("Models\\ship1");
        }

        public void DrawScene(Camera camera)
        {
            this.m_pGame.GraphicsDevice.RenderState.DepthBufferEnable = true;
            this.m_pGame.GraphicsDevice.RenderState.CullMode = CullMode.CullCounterClockwiseFace;
            this.m_pGame.GraphicsDevice.RenderState.AlphaBlendEnable = false;

            foreach (ModelMesh mesh in this.m_mShipModel.Meshes)
            {
                foreach (ModelMeshPart meshPart in mesh.MeshParts)
                {
                    foreach(Effect effect in mesh.Effects)
                    {
                        effect.Parameters["World"].SetValue(Matrix.Identity);
                        effect.Parameters["View"].SetValue(camera.View);
                        effect.Parameters["Projection"].SetValue(camera.Projection);
                    }
                    mesh.Draw();
                }
            }
        }
        #endregion

    } 
}
