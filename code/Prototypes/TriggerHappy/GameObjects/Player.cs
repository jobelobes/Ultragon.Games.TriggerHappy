using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework;

using TriggerHappy.GameObjects.Modifiers;

namespace TriggerHappy.GameObjects
{
    public class Player : Microsoft.Xna.Framework.DrawableGameComponent
    {
        #region Static Variables
        private static readonly int MoveAmount = 7;
        #endregion

        #region Variables
        private System.Int32 _selectedModifier;
        private System.Single _rotation;
        private Microsoft.Xna.Framework.Vector2 _position;
        private Microsoft.Xna.Framework.Graphics.Color _color;
        private Microsoft.Xna.Framework.Graphics.Texture2D _texture;

        private Microsoft.Xna.Framework.Graphics.SpriteBatch _spritebatch;

        private Microsoft.Xna.Framework.Input.MouseState _previousMouse;
        private Microsoft.Xna.Framework.Input.KeyboardState _previousKeyboard;
        #endregion

        #region Constructors and Finalizers
        public Player(Game game, Color color)
            : base(game)
        {
            this._rotation = 0;
            this._position = Vector2.Zero;
            this._color = color;
        }
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

            this._texture = this.Game.Content.Load<Texture2D>("Unit");
        }

        public override void Update(Microsoft.Xna.Framework.GameTime gameTime)
        {
            base.Update(gameTime);

            Level level = (this.Game as Game1).Level;

            KeyboardState currentKeyboard = Keyboard.GetState();
            MouseState currentMouse = Mouse.GetState();

            Vector2 orientation = this._position - (this.Game as Game1).Level.Position - new Vector2(currentMouse.X, currentMouse.Y);
            if (orientation.Length() > 150)
            {
                orientation.Normalize();
                orientation *= 150;
            }

            this._rotation = (float)Math.Atan2(orientation.Y, orientation.X) - MathHelper.PiOver2;

            if(this._previousKeyboard.IsKeyDown(Keys.NumPad1) || currentKeyboard.IsKeyUp(Keys.NumPad1))
                this._selectedModifier = 0;
            if(this._previousKeyboard.IsKeyDown(Keys.NumPad2) || currentKeyboard.IsKeyUp(Keys.NumPad2))
                this._selectedModifier = 1;

            Vector2 offset = Vector2.Zero;
            if (currentKeyboard.IsKeyDown(Keys.Left) || currentKeyboard.IsKeyDown(Keys.Right))
                offset.X += MoveAmount * (currentKeyboard.IsKeyDown(Keys.Left) ? -1 : 1);
            if (currentKeyboard.IsKeyDown(Keys.Up) || currentKeyboard.IsKeyDown(Keys.Down))
                offset.Y += MoveAmount * (currentKeyboard.IsKeyDown(Keys.Up) ? -1 : 1);

            this._position += offset;
            

            (this.Game as Game1).Level.CenterOn(this._position);

            if (currentMouse.LeftButton == ButtonState.Released && this._previousMouse.LeftButton == ButtonState.Pressed)
            {
                switch(this._selectedModifier)
                {
                    case 0:
                        this.Game.Components.Add(new SpeedModifier(this.Game, this._position - orientation));
                        break;
                    case 1:
                        this.Game.Components.Add(new TeleportModifier(this.Game, this._position - orientation));
                        break;
                }
                
            }

            this._position.X = Math.Min(Math.Max(0, this._position.X), level.Size.X);
            this._position.Y = Math.Min(Math.Max(0, this._position.Y), level.Size.Y);

            this._previousKeyboard = currentKeyboard;
            this._previousMouse = currentMouse;
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
                    this._rotation,
                    new Vector2(this._texture.Width / 2, this._texture.Height / 2),
                    SpriteEffects.None,
                    0);
            }
            this._spritebatch.End();
        }
        #endregion
    }
}
