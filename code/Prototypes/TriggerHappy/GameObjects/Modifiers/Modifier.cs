using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework;

namespace TriggerHappy.GameObjects.Modifiers
{
    public abstract class Modifier : Microsoft.Xna.Framework.DrawableGameComponent
    {
        #region Variables
        private Microsoft.Xna.Framework.Vector2 _position;
        private Microsoft.Xna.Framework.Graphics.Color _color;
        private Microsoft.Xna.Framework.Graphics.Texture2D _texture;

        private Microsoft.Xna.Framework.Graphics.SpriteBatch _spritebatch;
        #endregion

        #region Constructors and Finalizers
        public Modifier(Game game, Color color, Vector2 position)
            : base(game)
        {
            this._position = position;
            this._color = color;
        }
        #endregion

        #region Methods
        public abstract Boolean CanActivate(Player player);
        #endregion

        #region Overriden Methods
        public override void Initialize()
        {
            base.Initialize();

            this._spritebatch = new SpriteBatch(this.Game.GraphicsDevice);
        }

        protected override void LoadContent()
        {
            base.LoadContent();

            this._texture = this.Game.Content.Load<Texture2D>("Modifier");
        }

        public override void Draw(Microsoft.Xna.Framework.GameTime gameTime)
        {
            base.Draw(gameTime);

            Vector2 offsetPosition = this._position - (this.Game as Game1).Level.Position;

            this._spritebatch.Begin();
            {
                this._spritebatch.Draw(this._texture,
                    new Rectangle((int)offsetPosition.X, (int)offsetPosition.Y, this._texture.Width, this._texture.Height),
                    new Rectangle(0, 0, this._texture.Width, this._texture.Height),
                    this._color,
                    0,
                    new Vector2(this._texture.Width / 2, this._texture.Height / 2),
                    SpriteEffects.None,
                    1);
            }
            this._spritebatch.End();
        }
        #endregion
    }
}
